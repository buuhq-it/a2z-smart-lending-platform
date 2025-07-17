import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { CardModule } from 'primeng/card';
import { TableModule } from 'primeng/table';
import { ChartModule } from 'primeng/chart';
import { Router } from '@angular/router';
import { HttpClient } from '@angular/common/http';
import { ToastModule } from 'primeng/toast';
import { MessageService } from 'primeng/api';

@Component({
  selector: 'admin-dashboard',
  standalone: true,
  imports: [CommonModule, CardModule, TableModule, ChartModule, ToastModule],
  providers: [MessageService],
  template: `
    <p-toast></p-toast>
    <div class="p-4 grid grid-cols-1 md:grid-cols-4 gap-4">
      <!-- Tổng quan số liệu -->
      <p-card header="Tổng khoản vay" class="col-span-1">
        <div class="text-3xl font-bold text-primary">{{ loanList.length }}</div>
        <div class="text-muted">Khoản vay</div>
      </p-card>
      <p-card header="Tổng tiền giải ngân" class="col-span-1">
        <div class="text-3xl font-bold text-green-600">{{ getTotalDisbursed() | number }}đ</div>
        <div class="text-muted">VNĐ</div>
      </p-card>
      <p-card header="Khách hàng" class="col-span-1">
        <div class="text-3xl font-bold text-blue-600">{{ getCustomerCount() }}</div>
        <div class="text-muted">Khách hàng</div>
      </p-card>
      <p-card header="Hồ sơ đang xử lý" class="col-span-1">
        <div class="text-3xl font-bold text-orange-500">{{ getPendingCount() }}</div>
        <div class="text-muted">Hồ sơ</div>
      </p-card>
    </div>
    <div class="p-4 grid grid-cols-1 md:grid-cols-2 gap-4">
      <!-- Biểu đồ doanh thu -->
      <p-card header="Doanh thu theo tháng">
        <p-chart type="bar" [data]="revenueChartData" [options]="chartOptions"></p-chart>
      </p-card>
      <!-- Biểu đồ tỷ lệ duyệt hồ sơ -->
      <p-card header="Tỷ lệ duyệt hồ sơ">
        <p-chart type="doughnut" [data]="approvalChartData" [options]="chartOptions"></p-chart>
      </p-card>
    </div>
    <div class="p-4">
      <!-- Danh sách hồ sơ mới nhất -->
      <p-card header="Danh sách khoản vay">
        <p-table [value]="loanList" [paginator]="true" [rows]="10">
          <ng-template pTemplate="header">
            <tr>
              <th>ID</th>
              <th>ProcessInstance</th>
              <th>Khách hàng</th>
              <th>Số tiền vay</th>
              <th>Kỳ hạn</th>
              <th>Lãi suất</th>
              <th>Trạng thái</th>
              <th>Giai đoạn</th>
              <th>Duyệt</th>
            </tr>
          </ng-template>
          <ng-template pTemplate="body" let-app>
            <tr>
              <td>{{ app.id }}</td>
              <td>{{ app.processInstance }}</td>
              <td>{{ app.customerFullName }}</td>
              <td>
                <span style="color: #16a34a; font-weight: 600;">{{ app.loanAmount | number }}đ</span>
              </td>
              <td>{{ app.tenor }}</td>
              <td>
                <span style="color: #2563eb; font-weight: 600;">{{ app.loanRate * 100 }}%</span>
              </td>
              <td>
                <span [ngStyle]="{
                  'background': app.appStatus === 'Pending' ? '#fbbf24' : (app.appStatus === 'Approved' ? '#4ade80' : '#f87171'),
                  'color': '#fff',
                  'padding': '4px 12px',
                  'border-radius': '12px',
                  'font-weight': 600
                }">
                  {{ app.appStatus }}
                </span>
              </td>
              <td>{{ app.appStage }}</td>
              <td>
                <button *ngIf="app.appStatus === 'Pending'" pButton type="button" label="Duyệt" size="small" severity="success" (click)="approveLoan(app)"></button>
              </td>
            </tr>
          </ng-template>
        </p-table>
      </p-card>
    </div>
  `
})
export class AdminDashboardComponent implements OnInit {
  private http = inject(HttpClient);
  private messageService = inject(MessageService);
  loanList: any[] = [];

  revenueChartData = {
    labels: ['Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6'],
    datasets: [
      {
        label: 'Doanh thu',
        backgroundColor: '#42A5F5',
        data: [1200, 1900, 3000, 5000, 2300, 4000]
      }
    ]
  };

  approvalChartData = {
    labels: ['Duyệt', 'Từ chối', 'Đang xử lý'],
    datasets: [
      {
        data: [65, 20, 15],
        backgroundColor: ['#66BB6A', '#EF5350', '#FFA726'],
        hoverBackgroundColor: ['#81C784', '#E57373', '#FFB74D']
      }
    ]
  };

  chartOptions = {
    responsive: true,
    plugins: {
      legend: {
        display: true,
        position: 'bottom'
      }
    }
  };

  ngOnInit() {
    this.http.get<any>('https://smart-lending.technote.online/api/process/demo-onboarding/getAllApps')
      .subscribe({
        next: (res) => {
          if (res && res.body) {
            this.loanList = res.body;
          }
        },
        error: (err) => {
          // Có thể hiện toast hoặc log lỗi
          console.error('Lỗi lấy danh sách khoản vay:', err);
        }
      });
  }

  getTotalDisbursed(): number {
    return this.loanList.reduce((sum, app) => sum + (app.loanAmount || 0), 0);
  }

  getCustomerCount(): number {
    // Đếm số khách hàng duy nhất theo customerNationalId
    const unique = new Set(this.loanList.map(app => app.customerNationalId));
    return unique.size;
  }

  getPendingCount(): number {
    return this.loanList.filter(app => app.appStatus === 'Pending').length;
  }

  approveLoan(app: any) {
    const payload = {
      requestId: Date.now().toString() + Math.random().toString(36).substr(2, 9),
      traceId: Math.random().toString(36).substr(2, 8),
      requestTime: new Date().toISOString(),
      body: {
        processInstanceId: app.processInstance
      },
      metadata: {
        additionalProp1: {},
        additionalProp2: {},
        additionalProp3: {}
      }
    };
    this.http.post<any>('https://smart-lending.technote.online/api/process/demo-onboarding/esign', payload)
      .subscribe({
        next: (res) => {
          if (res && res.success) {
            this.messageService.add({severity: 'success', summary: 'Thành công', detail: 'Duyệt khoản vay thành công!'});
            // Cập nhật lại danh sách
            this.ngOnInit();
          } else {
            this.messageService.add({severity: 'error', summary: 'Lỗi', detail: res.errorDesc || 'Duyệt khoản vay thất bại!'});
          }
        },
        error: (err) => {
          this.messageService.add({severity: 'error', summary: 'Lỗi', detail: 'Duyệt khoản vay thất bại!'});
        }
      });
  }
} 