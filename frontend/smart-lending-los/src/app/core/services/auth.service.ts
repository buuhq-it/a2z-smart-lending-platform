import {Injectable} from '@angular/core';
import {HttpClient} from '@angular/common/http';
import {Router} from '@angular/router';
import {JwtModel, LoginRequestModel} from '../models/auth.model';
import {environment} from '../../../environments/environment';
import {jwtDecode} from 'jwt-decode';

@Injectable({
  providedIn: 'root'
})
export class AuthService {

  private readonly tokenKey = 'ais-jwt-token';

  constructor(private http: HttpClient, private router: Router) {}

  login(email: string, password: string) {
    const payload: LoginRequestModel = {
      requestId: 'req-' + Date.now(),
      traceId: 'trace-' + Date.now(),
      requestTime: new Date().toISOString(),
      body: {
        username: email,
        password: password
      }
    };

    return this.http.post<any>(`${environment.apiBaseUrl}/auth/login`, payload);
  }

  logout(): void {
    localStorage.removeItem(this.tokenKey);
    this.router.navigate(['/auth/login']);
  }

  setToken(token: string): void {
    localStorage.setItem(this.tokenKey, token);
  }

  getToken(): string | null {
    return localStorage.getItem(this.tokenKey);
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

  isLoggedIn(): boolean {
    const token = this.getToken();
    if (!token) return false;

    try {
      const decoded: JwtModel = jwtDecode(token);
      if (decoded.exp) {
        const now = Math.floor(Date.now() / 1000);
        return decoded.exp > now;
      }
      return true;
    } catch {
      return false;
    }
  }
}
