import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/dashboard_models.dart';
import 'stat_card.dart';

class LoanListItem extends StatelessWidget {
  final LoanSummary loan;
  final VoidCallback? onTap;

  const LoanListItem({
    super.key,
    required this.loan,
    this.onTap,
  });

  LoanStatus _getLoanStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return LoanStatus.pending;
      case 'active':
        return LoanStatus.active;
      case 'completed':
        return LoanStatus.completed;
      case 'overdue':
        return LoanStatus.overdue;
      default:
        return LoanStatus.pending;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = _getLoanStatus(loan.status);
    final isOverdue = status == LoanStatus.overdue;
    final daysUntilDue = loan.dueDate.difference(DateTime.now()).inDays;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: isOverdue ? Border.all(color: Colors.red.withOpacity(0.3)) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          loan.customerName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'ID: ${loan.id}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: status.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      status.label,
                      style: TextStyle(
                        color: status.color,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.phone,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    loan.phoneNumber,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    formatCurrency(loan.amount),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: isOverdue ? Colors.red : Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('dd/MM/yyyy').format(loan.dueDate),
                    style: TextStyle(
                      fontSize: 14,
                      color: isOverdue ? Colors.red : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (status == LoanStatus.active || status == LoanStatus.overdue)
                    Text(
                      isOverdue 
                        ? '(Quá hạn ${-daysUntilDue} ngày)'
                        : '(Còn $daysUntilDue ngày)',
                      style: TextStyle(
                        fontSize: 12,
                        color: isOverdue ? Colors.red : Colors.orange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
