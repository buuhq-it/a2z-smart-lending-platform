import { Injectable } from '@angular/core'
import { HttpClient } from '@angular/common/http'
import { BehaviorSubject, Observable } from 'rxjs'
import { map } from 'rxjs/operators'

interface ApiRequest {
  requestId: string
  traceId: string
  requestTime: string
  body: any
  metadata: any
}

interface ApiResponse {
  requestId: string
  traceId: string
  body: any
  errorCode: string | null
  errorDesc: string | null
  success: boolean
  totalSize: number
  pageSize: number
  pageIndex: number
  timestamp: string
  metadata: any
}

@Injectable({
  providedIn: 'root'
})
export class AuthService {
  private apiUrl = '' // Sử dụng proxy để tránh CORS, apiUrl để rỗng
  private currentUserSubject: BehaviorSubject<any>
  public currentUser: Observable<any>

  constructor(private http: HttpClient) {
    this.currentUserSubject = new BehaviorSubject<any>(
      this.getCurrentUser()
    )
    this.currentUser = this.currentUserSubject.asObservable()
  }

  public get currentUserValue() {
    return this.currentUserSubject.value
  }

  private generateRequestId(): string {
    return Date.now().toString() + Math.random().toString(36).substr(2, 9)
  }

  private generateTraceId(): string {
    return Math.random().toString(36).substr(2, 8)
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
        additionalProp3: {}
      }
    }
  }

  login(username: string, password: string, rememberMe: boolean = false): Observable<ApiResponse> {
    const request = this.createApiRequest({ username, password })
    
    return this.http.post<ApiResponse>(`${this.apiUrl}/api/auth/login`, request).pipe(
      map(response => {
        if (response.success && response.body?.token) {
          const storage = rememberMe ? localStorage : sessionStorage
          storage.setItem('token', response.body.token)
          storage.setItem('username', username)
          storage.setItem('loginTime', new Date().toISOString())
          
          // Decode JWT to get user info
          const userInfo = this.decodeJWT(response.body.token)
          if (userInfo) {
            storage.setItem('currentUser', JSON.stringify(userInfo))
            this.currentUserSubject.next(userInfo)
          }
        }
        return response
      })
    )
  }

  

  isAuthenticated(): boolean {
    const token = this.getToken()
    if (!token) return false
    
    // Check if token is expired
    const userInfo = this.decodeJWT(token)
    if (userInfo && userInfo.exp) {
      const currentTime = Math.floor(Date.now() / 1000)
      return userInfo.exp > currentTime
    }
    
    return false
  }

  getToken(): string | null {
    return localStorage.getItem('token') || sessionStorage.getItem('token')
  }

  getCurrentUser(): any {
    const userStr = localStorage.getItem('currentUser') || sessionStorage.getItem('currentUser')
    return userStr ? JSON.parse(userStr) : null
  }

  private decodeJWT(token: string): any {
    try {
      const payload = token.split('.')[1]
      const decoded = atob(payload)
      return JSON.parse(decoded)
    } catch (error) {
      console.error('Error decoding JWT:', error)
      return null
    }
  }

  hasRole(role: string): boolean {
    const user = this.getCurrentUser()
    return user && user.roles && user.roles.includes(role)
  }

  isAdmin(): boolean {
    return this.hasRole('ROLE_ADMIN')
  }
}