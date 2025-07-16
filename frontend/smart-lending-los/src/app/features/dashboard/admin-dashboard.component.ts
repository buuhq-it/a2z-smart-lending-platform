import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { CardModule } from 'primeng/card';
import { TableModule } from 'primeng/table';
import { ChartModule } from 'primeng/chart';
import { Router } from '@angular/router';

@Component({
  selector: 'admin-dashboard',
  standalone: true,
  imports: [CommonModule, CardModule, TableModule, ChartModule],
  template: `
    <div class="p-4 grid grid-cols-1 md:grid-cols-4 gap-4">
      <!-- Tổng quan số liệu -->
      <p-card header="Tổng khoản vay" class="col-span-1">
        <div class="text-3xl font-bold text-primary">1,250</div>
        <div class="text-muted">Khoản vay</div>
      </p-card>
      <p-card header="Tổng tiền giải ngân" class="col-span-1">
        <div class="text-3xl font-bold text-green-600">12,500,000,000đ</div>
        <div class="text-muted">VNĐ</div>
      </p-card>
      <p-card header="Khách hàng" class="col-span-1">
        <div class="text-3xl font-bold text-blue-600">980</div>
        <div class="text-muted">Khách hàng</div>
      </p-card>
      <p-card header="Hồ sơ đang xử lý" class="col-span-1">
        <div class="text-3xl font-bold text-orange-500">32</div>
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
      <p-card header="Hồ sơ mới nhất">
        <p-table [value]="latestApplications" [paginator]="true" [rows]="5">
          <ng-template pTemplate="header">
            <tr>
              <th>Khách hàng</th>
              <th>Số tiền vay</th>
              <th>Trạng thái</th>
              <th>Ngày tạo</th>
            </tr>
          </ng-template>
          <ng-template pTemplate="body" let-app>
            <tr>
              <td>{{ app.customer }}</td>
              <td>{{ app.amount | number }}đ</td>
              <td>{{ app.status }}</td>
              <td>{{ app.createdAt | date:'short' }}</td>
            </tr>
          </ng-template>
        </p-table>
      </p-card>
    </div>
  `
})
export class AdminDashboardComponent {
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

  latestApplications = [
    { customer: 'Nguyễn Văn A', amount: 50000000, status: 'Đang xử lý', createdAt: new Date() },
    { customer: 'Trần Thị B', amount: 20000000, status: 'Duyệt', createdAt: new Date(Date.now() - 86400000) },
    { customer: 'Lê Văn C', amount: 100000000, status: 'Từ chối', createdAt: new Date(Date.now() - 2*86400000) },
    { customer: 'Phạm Thị D', amount: 30000000, status: 'Đang xử lý', createdAt: new Date(Date.now() - 3*86400000) },
    { customer: 'Vũ Văn E', amount: 15000000, status: 'Duyệt', createdAt: new Date(Date.now() - 4*86400000) },
  ];
} 