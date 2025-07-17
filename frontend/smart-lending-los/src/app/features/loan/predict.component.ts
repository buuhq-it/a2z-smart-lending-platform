import { FormsModule } from "@angular/forms"
import { CommonModule } from "@angular/common"
import { Component, inject } from "@angular/core"
import { HttpClient } from "@angular/common/http"
import { InputNumberModule } from "primeng/inputnumber"
import { DropdownModule } from "primeng/dropdown"
import { ButtonModule } from "primeng/button"
import { CardModule } from "primeng/card"
import { ProgressSpinnerModule } from "primeng/progressspinner"

interface FormData {
  AMT_INCOME_TOTAL: number
  AMT_CREDIT: number
  AMT_ANNUITY: number
  AMT_GOODS_PRICE: number
  AGE: number 
  DAYS_EMPLOYED: number
  CNT_CHILDREN: number
  FLAG_OWN_CAR: number
  FLAG_OWN_REALTY: number
}

interface PredictResult {
  prediction: string
  probability_default: number
  probability_repaid: number
  risk_level: string
}

@Component({
  selector: "app-predict",
  standalone: true,
  imports: [
    CommonModule,
    FormsModule,
    InputNumberModule,
    DropdownModule,
    ButtonModule,
    CardModule,
    ProgressSpinnerModule,
  ],
  templateUrl: "./predict.component.html",
  styleUrl: "./predict.component.scss",
})
export class PredictComponent {
  private http = inject(HttpClient)

  formData: FormData = {
    AMT_INCOME_TOTAL: 0,
    AMT_CREDIT: 0,
    AMT_ANNUITY: 0,
    AMT_GOODS_PRICE: 0,
    AGE: 0,
    DAYS_EMPLOYED: 0,
    CNT_CHILDREN: 0,
    FLAG_OWN_CAR: 0,
    FLAG_OWN_REALTY: 0,
  }

  carOptions = [
    { label: "Có", value: 1 },
    { label: "Không", value: 0 },
  ]

  realtyOptions = [
    { label: "Có", value: 1 },
    { label: "Không", value: 0 },
  ]

  predictResult: PredictResult | null = null
  predicting = false

  constructor() {}

  onSubmit() {
    this.predicting = true
    this.predictResult = null

    const apiData = {
      ...this.formData,
      DAYS_BIRTH: this.formData.AGE ? -(this.formData.AGE * 365) : null,
      EXT_SOURCE_2: 1,
    }

    delete (apiData as any).AGE

    this.http.post<any>("https://smart-lending.technote.online/ai/predict", apiData).subscribe({
      next: (res: any) => {
        this.predictResult = res.prediction
        this.predicting = false
      },
      error: (err: any) => {
        console.error("API Error:", err)
        alert("Có lỗi khi gọi API predict!")
        this.predicting = false
      },
    })
  }

  formatCurrency(value: number): string {
    if (!value) return ""
    return new Intl.NumberFormat("vi-VN", {
      style: "currency",
      currency: "VND",
    }).format(value)
  }

  getYearsFromDays(days: number): number {
    if (!days) return 0
    return Math.round(days / 365)
  }

  getRiskLevelClass(riskLevel: string): string {
    if (!riskLevel) return "bg-gray-100 text-gray-800 border border-gray-200"

    switch (riskLevel.toLowerCase()) {
      case "low":
      case "thấp":
        return "bg-green-100 text-green-800 border border-green-200"
      case "medium":
      case "trung bình":
        return "bg-yellow-100 text-yellow-800 border border-yellow-200"
      case "high":
      case "cao":
        return "bg-red-100 text-red-800 border border-red-200"
      default:
        return "bg-gray-100 text-gray-800 border border-gray-200"
    }
  }
}
