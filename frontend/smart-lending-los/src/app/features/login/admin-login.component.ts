import { FormsModule } from "@angular/forms"
import { CommonModule } from "@angular/common"
import { Component, inject, OnInit } from "@angular/core"
import { HttpClient } from "@angular/common/http"
import { Router } from "@angular/router"
import { InputTextModule } from "primeng/inputtext"
import { PasswordModule } from "primeng/password"
import { ButtonModule } from "primeng/button"
import { CardModule } from "primeng/card"
import { CheckboxModule } from "primeng/checkbox"
import { MessageModule } from "primeng/message"
import { ProgressSpinnerModule } from "primeng/progressspinner"

interface LoginData {
  username: string
  password: string
  rememberMe: boolean
}

interface ApiRequest {
  requestId: string
  traceId: string
  requestTime: string
  body: {
    username: string
    password: string
  }
  metadata: {
    additionalProp1?: any
    additionalProp2?: any
    additionalProp3?: any
  }
}

interface ApiResponse {
  requestId: string
  traceId: string
  body: {
    token: string
  }
  errorCode: string | null
  errorDesc: string | null
  success: boolean
  totalSize: number
  pageSize: number
  pageIndex: number
  timestamp: string
  metadata: any
}

@Component({
  selector: "app-admin-login",
  standalone: true,
  imports: [
    CommonModule,
    FormsModule,
    InputTextModule,
    PasswordModule,
    ButtonModule,
    CardModule,
    CheckboxModule,
    MessageModule,
    ProgressSpinnerModule,
  ],
  templateUrl: "./admin-login.component.html",
  styleUrl: "./admin-login.component.scss",
})
export class AdminLoginComponent implements OnInit {
  private http = inject(HttpClient)
  private router = inject(Router)

  loginData: LoginData = {
    username: "",
    password: "",
    rememberMe: false,
  }

  isLoading = false
  errorMessage = ""

  constructor() {}

  ngOnInit() {
    const token = localStorage.getItem('token') || sessionStorage.getItem('token');
    if (token) {
      this.router.navigate(['/admin/dashboard']);
    }
  }

  private generateRequestId(): string {
    // return Date.now().toString() + Math.random().toString(36).substr(2, 9)
    return "112233445566"
  }

  private generateTraceId(): string {
    // return Math.random().toString(36).substr(2, 8)
    return "11223344"
  }

  onSubmit() {
    this.isLoading = true
    this.errorMessage = ""

    // Validate form
    if (!this.loginData.username || !this.loginData.password) {
      this.errorMessage = "Vui lòng nhập đầy đủ thông tin đăng nhập"
      this.isLoading = false
      return
    }

    // Prepare API request according to your format
    const now = new Date();
    const apiRequest: ApiRequest = {
      requestId: this.generateRequestId(),
      traceId: this.generateTraceId(),
      requestTime: now.toISOString(),
      body: {
        username: this.loginData.username,
        password: this.loginData.password
      },
      metadata: {
        additionalProp1: {},
        additionalProp2: {},
        additionalProp3: {}
      }
    }

    // Log chi tiết từng trường
    console.log('Login API Request:', apiRequest);
    console.log('requestId:', apiRequest.requestId);
    console.log('traceId:', apiRequest.traceId);
    console.log('requestTime:', apiRequest.requestTime);
    console.log('username:', apiRequest.body.username);
    console.log('password:', apiRequest.body.password);
    console.log('metadata:', apiRequest.metadata);

    // Call login API
    this.http.post<ApiResponse>("https://smart-lending.technote.online/api/auth/login", apiRequest).subscribe({
      next: (response: ApiResponse) => {
        console.log('Login API Response:', response);
        if (response.success && response.body?.token) {
          // Save token and user info
          const storage = this.loginData.rememberMe ? localStorage : sessionStorage
          storage.setItem('token', response.body.token)
          storage.setItem('username', this.loginData.username)
          storage.setItem('loginTime', new Date().toISOString())
          // Redirect to dashboard
          this.router.navigate(['/admin/dashboard'])
        } else {
          this.errorMessage = response.errorDesc || "Đăng nhập thất bại"
        }
        this.isLoading = false
      },
      error: (err: any) => {
        console.error('Login API Error:', err);
        if (err && err.error) {
          console.error('Login API Error Body:', err.error);
        }
        // Handle different error scenarios
        if (err.status === 401) {
          this.errorMessage = "Tên đăng nhập hoặc mật khẩu không đúng"
        } else if (err.status === 0) {
          this.errorMessage = "Không thể kết nối đến server. Vui lòng thử lại."
        } else if (err.error?.errorDesc) {
          this.errorMessage = err.error.errorDesc
        } else {
          this.errorMessage = "Đăng nhập thất bại. Vui lòng thử lại."
        }
        this.isLoading = false
      },
    })
  }

  // Optional: Decode JWT token to get user information
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

  onForgotPassword() {
    // Navigate to forgot password page or show modal
    console.log("Forgot password clicked")
    // this.router.navigate(['/auth/forgot-password'])
  }

}