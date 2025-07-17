import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Router } from '@angular/router';
import { BehaviorSubject, Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { JwtModel, LoginRequestModel } from '../models/auth.model';
import { environment } from '../../../environments/environment';
import { jwtDecode } from 'jwt-decode';

interface ApiRequest {
  requestId: string;
  traceId: string;
  requestTime: string;
  body: any;
  metadata: any;
}

interface ApiResponse {
  requestId: string;
  traceId: string;
  body: any;
  errorCode: string | null;
  errorDesc: string | null;
  success: boolean;
  totalSize: number;
  pageSize: number;
  pageIndex: number;
  timestamp: string;
  metadata: any;
}

@Injectable({
  providedIn: 'root',
})
export class AuthService {
  private apiUrl = environment.apiBaseUrl || 'https://smart-lending.technote.online/api';
  private currentUserSubject: BehaviorSubject<any>;
  public currentUser: Observable<any>;
  private readonly tokenKey = 'token';

  constructor(private http: HttpClient, private router: Router) {
    this.currentUserSubject = new BehaviorSubject<any>(this.getCurrentUser());
    this.currentUser = this.currentUserSubject.asObservable();
  }

  public get currentUserValue() {
    return this.currentUserSubject.value;
  }

  private generateRequestId(): string {
    return Date.now().toString() + Math.random().toString(36).substr(2, 9);
  }

  private generateTraceId(): string {
    return Math.random().toString(36).substr(2, 8);
  }

  private createApiRequest(body: any): ApiRequest {
    return {
      requestId: this.generateRequestId(),
      traceId: this.generateTraceId(),
      requestTime: new Date().toISOString(),
      body: body,
      metadata: {
        additionalProp1: {},
        additionalProp2: {},
        additionalProp3: {},
      },
    };
  }

  login(username: string, password: string, rememberMe: boolean = false): Observable<ApiResponse> {
    const request = this.createApiRequest({ username, password });
    return this.http.post<ApiResponse>(`${this.apiUrl}/auth/login`, request).pipe(
      map((response) => {
        if (response.success && response.body?.token) {
          const storage = rememberMe ? localStorage : sessionStorage;
          storage.setItem(this.tokenKey, response.body.token);
          storage.setItem('username', username);
          storage.setItem('loginTime', new Date().toISOString());
          // Decode JWT to get user info
          const userInfo = this.decodeJWT(response.body.token);
          if (userInfo) {
            storage.setItem('currentUser', JSON.stringify(userInfo));
            this.currentUserSubject.next(userInfo);
          }
        }
        return response;
      })
    );
  }

  setToken(token: string, rememberMe: boolean = false): void {
    const storage = rememberMe ? localStorage : sessionStorage;
    storage.setItem(this.tokenKey, token);
  }

  getToken(): string | null {
    return localStorage.getItem(this.tokenKey) || sessionStorage.getItem(this.tokenKey);
  }

  getUsername(): string | null {
    const token = this.getToken();
    if (token) {
      try {
        const decoded: JwtModel = jwtDecode(token);
        return decoded.sub || decoded['username'] || null;
      } catch (err) {
        console.error('Failed to decode token', err);
      }
    }
    return null;
  }

  getCurrentUser(): any {
    const userStr = localStorage.getItem('currentUser') || sessionStorage.getItem('currentUser');
    return userStr ? JSON.parse(userStr) : null;
  }

  private decodeJWT(token: string): any {
    try {
      const payload = token.split('.')[1];
      const decoded = atob(payload);
      return JSON.parse(decoded);
    } catch (error) {
      console.error('Error decoding JWT:', error);
      return null;
    }
  }

  isLoggedIn(): boolean {
    return this.isAuthenticated();
  }

  isAuthenticated(): boolean {
    const token = this.getToken();
    if (!token) return false;
    // Check if token is expired
    const userInfo = this.decodeJWT(token);
    if (userInfo && userInfo.exp) {
      const currentTime = Math.floor(Date.now() / 1000);
      return userInfo.exp > currentTime;
    }
    return false;
  }

  hasRole(role: string): boolean {
    const user = this.getCurrentUser();
    return user && user.roles && user.roles.includes(role);
  }

  isAdmin(): boolean {
    return this.hasRole('ROLE_ADMIN');
  }

  logout() {
    localStorage.removeItem(this.tokenKey);
    localStorage.removeItem('username');
    localStorage.removeItem('loginTime');
    localStorage.removeItem('currentUser');
    sessionStorage.removeItem(this.tokenKey);
    sessionStorage.removeItem('username');
    sessionStorage.removeItem('loginTime');
    sessionStorage.removeItem('currentUser');
    this.currentUserSubject.next(null);
  }
}
