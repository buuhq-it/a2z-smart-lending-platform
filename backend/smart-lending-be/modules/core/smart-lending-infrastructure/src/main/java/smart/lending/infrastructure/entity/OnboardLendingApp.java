package smart.lending.infrastructure.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "onboard_lending_apps")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
//@Builder
public class OnboardLendingApp {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String processInstance;
    private String customerNationalId;
    private String customerFullName;
    private String customerEmail;
    private String customerPhone;
    private String customerAddress;
    private int loanAmount;
    private double loanRate;
    private int tenor;
    private int income;
    private int age;
    private int gender;
    private int numberOfChildren;
    private boolean hasOwnCar;
    private boolean hasOwnRealty;
    private String appStatus;
    private String appStage;
}
