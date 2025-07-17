import { FormsModule } from "@angular/forms"
import { CommonModule } from "@angular/common"
import { Component, inject } from "@angular/core"
import { HttpClient, HttpHeaders } from "@angular/common/http"
import { Router } from "@angular/router"
import { InputTextModule } from "primeng/inputtext"
import { InputNumberModule } from "primeng/inputnumber"
import { DropdownModule } from "primeng/dropdown"
import { ButtonModule } from "primeng/button"
import { CardModule } from "primeng/card"
import { CheckboxModule } from "primeng/checkbox"
import { MessageModule } from "primeng/message"
import { ProgressSpinnerModule } from "primeng/progressspinner"
import { AuthService } from "../../core/services/auth.service"
import { ToastModule } from 'primeng/toast';
import { MessageService } from 'primeng/api';
// import { AuthService } from "./auth.service"

interface LoanData {
  customerNationalId: string
  customerFullName: string
  customerEmail: string
  customerPhone: string
  customerAddress: string
  loanAmount: number
  loanRate: number
  tenor: number
  income: number
  age: number
  gender: number
  numberOfChildren: number
  hasOwnCar: boolean
  hasOwnRealty: boolean
}

interface ApiRequest {
  requestId: string
  traceId: string
  requestTime: string
  body: LoanData
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

@Component({
  selector: "app-loan-creation",
  standalone: true,
  imports: [
    CommonModule,
    FormsModule,
    InputTextModule,
    InputNumberModule,
    DropdownModule,
    ButtonModule,
    CardModule,
    CheckboxModule,
    MessageModule,
    ProgressSpinnerModule,
    ToastModule,
  ],
  providers: [MessageService],
  templateUrl: "./loan-creation.component.html",
  styleUrl: "./loan-creation.component.scss",
})
export class LoanCreationComponent {
  private http = inject(HttpClient)
  private router = inject(Router)
  private authService = inject(AuthService)
  private messageService = inject(MessageService);

  loanData: LoanData = {
    customerNationalId: "",
    customerFullName: "",
    customerEmail: "",
    customerPhone: "",
    customerAddress: "",
    loanAmount: 0,
    loanRate: 0.1,
    tenor: 12,
    income: 0,
    age: 0,
    gender: 1,
    numberOfChildren: 0,
    hasOwnCar: false,
    hasOwnRealty: false,
  }

  genderOptions = [
    { label: "Nam", value: 1 },
    { label: "Nữ", value: 0 },
  ]

  tenorOptions = [
    { label: "6 tháng", value: 6 },
    { label: "12 tháng", value: 12 },
    { label: "18 tháng", value: 18 },
    { label: "24 tháng", value: 24 },
    { label: "36 tháng", value: 36 },
  ]

  loanRateOptions = [
    { label: "8% / năm", value: 0.08 },
    { label: "10% / năm", value: 0.1 },
    { label: "12% / năm", value: 0.12 },
    { label: "15% / năm", value: 0.15 },
  ]

  isLoading = false
  errorMessage = ""
  successMessage = ""
  loanResult: any = null

  constructor() {
    // Check if user is authenticated
    if (!this.authService.isAuthenticated()) {
      this.router.navigate(['/auth/admin/login'])
    }
  }

  private generateRequestId(): string {
    return Date.now().toString() + Math.random().toString(36).substr(2, 9)
  }

  private generateTraceId(): string {
    return Math.random().toString(36).substr(2, 8)
  }

  onSubmit() {
    this.isLoading = true
    this.errorMessage = ""
    this.successMessage = ""
    this.loanResult = null

    // Validate form
    if (!this.validateForm()) {
      this.isLoading = false
      return
    }

    // Get token for authentication
    const token = this.authService.getToken()
    if (!token) {
      this.errorMessage = "Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại."
      this.router.navigate(['/auth/admin/login'])
      this.isLoading = false
      return
    }

    // Prepare API request
    const apiRequest: ApiRequest = {
      requestId: this.generateRequestId(),
      traceId: this.generateTraceId(),
      requestTime: new Date().toISOString(),
      body: { ...this.loanData }
    }

    // Set up headers with Bearer token
    const headers = new HttpHeaders({
      'Authorization': `Bearer ${token}`,
      'Content-Type': 'application/json'
    })

    // Call loan creation API
    this.http.post<ApiResponse>(
      "https://smart-lending.technote.online/api/process/demo-onboarding/acquisition", 
      apiRequest,
      { headers }
    ).subscribe({
      next: (response: ApiResponse) => {
      this.successMessage = "Tạo khoản vay thành công!"
        this.loanResult = response.body
        // Hiện popup
        this.messageService.add({severity: 'success', summary: 'Thành công', detail: 'Tạo khoản vay thành công!'});
        // Reset form after success
        this.resetForm()
        
        this.isLoading = false
      },
      error: (err: any) => {
        console.error("Loan Creation Error:", err)
        
        if (err.status === 401) {
          this.errorMessage = "Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại."
          this.authService.logout()
          this.router.navigate(['/auth/admin/login'])
        } else if (err.status === 403) {
          this.errorMessage = "Bạn không có quyền thực hiện chức năng này."
        } else if (err.status === 0) {
          this.errorMessage = "Không thể kết nối đến server. Vui lòng thử lại."
        } else if (err.error?.errorDesc) {
          this.errorMessage = err.error.errorDesc
        } else {
          this.errorMessage = "Tạo khoản vay thất bại. Vui lòng thử lại."
        }
        
        this.isLoading = false
      },
    })
  }

  private validateForm(): boolean {
    if (!this.loanData.customerNationalId) {
      this.errorMessage = "Vui lòng nhập CMND/CCCD"
      return false
    }
    if (!this.loanData.customerFullName) {
      this.errorMessage = "Vui lòng nhập họ tên khách hàng"
      return false
    }
    if (!this.loanData.customerEmail) {
      this.errorMessage = "Vui lòng nhập email khách hàng"
      return false
    }
    if (!this.loanData.customerPhone) {
      this.errorMessage = "Vui lòng nhập số điện thoại"
      return false
    }
    if (!this.loanData.loanAmount || this.loanData.loanAmount <= 0) {
      this.errorMessage = "Vui lòng nhập số tiền vay hợp lệ"
      return false
    }
    if (!this.loanData.income || this.loanData.income <= 0) {
      this.errorMessage = "Vui lòng nhập thu nhập hợp lệ"
      return false
    }
    if (!this.loanData.age || this.loanData.age < 18 || this.loanData.age > 100) {
      this.errorMessage = "Tuổi phải từ 18 đến 100"
      return false
    }
    return true
  }

  resetForm() {
    this.loanData = {
      customerNationalId: "",
      customerFullName: "",
      customerEmail: "",
      customerPhone: "",
      customerAddress: "",
      loanAmount: 0,
      loanRate: 0.1,
      tenor: 12,
      income: 0,
      age: 0,
      gender: 1,
      numberOfChildren: 0,
      hasOwnCar: false,
      hasOwnRealty: false,
    }
    this.errorMessage = ""
    this.successMessage = ""
    this.loanResult = null
  }

  formatCurrency(value: number): string {
    if (!value) return ""
    return new Intl.NumberFormat("vi-VN", {
      style: "currency",
      currency: "VND",
    }).format(value)
  }

  calculateMonthlyPayment(): number {
    if (!this.loanData.loanAmount || !this.loanData.loanRate || !this.loanData.tenor) {
      return 0
    }
    
    const monthlyRate = this.loanData.loanRate / 12
    const payment = (this.loanData.loanAmount * monthlyRate * Math.pow(1 + monthlyRate, this.loanData.tenor)) / 
                   (Math.pow(1 + monthlyRate, this.loanData.tenor) - 1)
    
    return payment
  }

  onLogout() {
    this.authService.logout()
    this.router.navigate(['/auth/admin/login'])
  }
}