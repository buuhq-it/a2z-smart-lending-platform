package smart.lending.domain.model;

import lombok.*;

@Getter @Setter @AllArgsConstructor @NoArgsConstructor @Builder
public class OnboardAcquisitionRequest {
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

}
