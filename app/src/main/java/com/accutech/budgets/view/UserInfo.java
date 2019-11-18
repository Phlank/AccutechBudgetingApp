package com.accutech.budgets.view;

import android.content.Intent;
import android.os.Bundle;
import android.text.InputType;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.ScrollView;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

import com.accutech.budgets.R;
import com.accutech.budgets.model.BudgetCreator;
import com.accutech.budgets.model.HousingOwnership;

public class UserInfo extends AppCompatActivity {

    private EditText pin, location, name , email, age, income, dependents, housingPayment, savings,
            debts;
    private ScrollView layoutParent;
    private LinearLayout[] layouts;
    private TextView pinLabel, incomeLabel, housingLabel, paymentLabel,locationLabel, savingsLabel,
            debtLabel;
    private LinearLayout nameLayout, incomeLayout, housingLayout, securityLayout, verifyLayout,
            locationLayout, savingsLayout;
    private RadioGroup housingType;
    private RadioButton rent, own;
    private Button next, submit;
    private int curr =0;
    private BudgetCreator creator = new BudgetCreator();
    //temporary
    private String sName, sAge, sEmail, sIncome, sLocation, sHousingType, sHousingPay, sSavings,
            sDebts;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_user_info);
        initVars();
        setNameLayout();
        next = findViewById(R.id.next);
        nameLayout = findViewById(R.id.infoLayout);
        layoutParent = findViewById(R.id.infoLayoutParent);
        layouts = new LinearLayout[]{incomeLayout, locationLayout, housingLayout, savingsLayout,
                securityLayout, verifyLayout};
        next.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                nextLayout();
            }
        });
        submit.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                submitData();
            }
        });

    }

    private void initVars() {
        pin = new EditText(getApplicationContext());
        location = new EditText(getApplicationContext());
        income = new EditText(getApplicationContext());
        dependents = new EditText(getApplicationContext());
        housingPayment = new EditText(getApplicationContext());
        savings = new EditText(getApplicationContext());
        debts = new EditText(getApplicationContext());
        pinLabel = new TextView(getApplicationContext());
        incomeLabel= new TextView(getApplicationContext());
        housingLabel= new TextView(getApplicationContext());
        paymentLabel = new TextView(getApplicationContext());
        locationLabel = new TextView(getApplicationContext());
        savingsLabel = new TextView(getApplicationContext());
        debtLabel = new TextView(getApplicationContext());
        incomeLayout = new LinearLayout(getApplicationContext());
        housingLayout = new LinearLayout(getApplicationContext());
        securityLayout = new LinearLayout(getApplicationContext());
        verifyLayout = new LinearLayout(getApplicationContext());
        locationLayout = new LinearLayout(getApplicationContext());
        savingsLayout = new LinearLayout(getApplicationContext());
        housingType = new RadioGroup(getApplicationContext());
        rent = new RadioButton(getApplicationContext());
        own = new RadioButton(getApplicationContext());
        submit = new Button(getApplicationContext());
    }

    private void setNameLayout() {
        name = findViewById(R.id.name);
        age = findViewById(R.id.age);
        email = findViewById(R.id.email);

    }

    private void setIncomeLayout() {
        nameLayout.removeAllViews();
        incomeLayout.setOrientation(LinearLayout.VERTICAL);
        incomeLabel.setText("How much do you get paid monthly");
        income.setInputType(InputType.TYPE_NUMBER_FLAG_DECIMAL);
        incomeLayout.addView(incomeLabel,0);
        incomeLayout.addView(income,1);
        incomeLayout.addView(next, 2);
    }

    private void setLocationLayout(){
        incomeLayout.removeAllViews();
        locationLayout.setOrientation(LinearLayout.VERTICAL);
        locationLabel.setText("What state do you live in?");
        locationLayout.addView(locationLabel,0);
        locationLayout.addView(location, 1);
        locationLayout.addView(next,2);
    }

    private void setHousingLayout() {
        locationLayout.removeAllViews();
        housingLayout.setOrientation(LinearLayout.VERTICAL);
        rent.setText("rent");
        own.setText("own");
        housingType.addView(rent,0);
        housingType.addView(own,1);
        housingLabel.setText("Do you Rent or Own");
        paymentLabel.setText("How much do you pay per month?");
        housingPayment.setInputType(InputType.TYPE_NUMBER_FLAG_DECIMAL);
        housingLayout.addView(housingLabel,0);
        housingLayout.addView(housingType, 1);
        housingLayout.addView(paymentLabel,2);
        housingLayout.addView(housingPayment, 3);
        housingLayout.addView(next, 4);
    }

    private void setsavingsLayout() {
        housingLayout.removeAllViews();
        savingsLayout.setOrientation(LinearLayout.VERTICAL);
        savingsLabel.setText("How much do you have saved?");
        debtLabel.setText("How Big are your debts?");
        savings.setInputType(InputType.TYPE_NUMBER_FLAG_DECIMAL);
        debts.setInputType(InputType.TYPE_NUMBER_FLAG_DECIMAL);
        savingsLayout.addView(savingsLabel,0);
        savingsLayout.addView(savings,1);
        savingsLayout.addView(debtLabel, 2);
        savingsLayout.addView(debts, 3);
        savingsLayout.addView(next,4);

    }

    private void setSecurityLayout() {
        savingsLayout.removeAllViews();
        securityLayout.setOrientation(LinearLayout.VERTICAL);
        pinLabel.setText("What do you want your PIN to be?");
        pin.setInputType(InputType.TYPE_NUMBER_VARIATION_PASSWORD);
        securityLayout.addView(pinLabel,0);
        securityLayout.addView(pin,1);
        securityLayout.addView(next, 2);
    }

    private void setVerifyLayout(){
        securityLayout.removeAllViews();
        verifyLayout.setOrientation(LinearLayout.VERTICAL);
        TextView checkName = new TextView(getApplicationContext()),
                checkAge = new TextView(getApplicationContext()),
                checkEmail = new TextView(getApplicationContext()),
                checkIncome = new TextView(getApplicationContext()),
                checkLocation = new TextView(getApplicationContext()),
                checkHousingType = new TextView(getApplicationContext()),
                checkHousingPayment = new TextView(getApplicationContext()),
                checkingSavings = new TextView(getApplicationContext()),
                checkingDebts = new TextView(getApplicationContext());
        checkName.setText("Name :"+sName);
        checkAge.setText("Age :"+sAge);
        checkEmail.setText("Email :"+sEmail);
        checkIncome.setText("Income: $"+sIncome);
        checkLocation.setText("locaton: "+sLocation);
        checkHousingType.setText("housing: "+sHousingType);
        checkHousingPayment.setText("housingPayment: "+sHousingPay);
        checkingSavings.setText("Savings: $"+sSavings);
        checkingDebts.setText("debts: $"+sDebts);
        submit.setText("Submit");
        verifyLayout.addView(checkName,0);
        verifyLayout.addView(checkEmail,1);
        verifyLayout.addView(checkAge,2);
        verifyLayout.addView(checkLocation,3);
        verifyLayout.addView(checkIncome,4);
        verifyLayout.addView(checkHousingType,5);
        verifyLayout.addView(checkHousingPayment,6);
        verifyLayout.addView(checkingSavings,7);
        verifyLayout.addView(checkingDebts, 8);
        verifyLayout.addView(submit,9);
    }

    private void nextLayout(){
        if(infoFull(layouts[curr])) {
            grabData();
            layoutParent.removeAllViewsInLayout();
            layoutParent.addView(layouts[curr]);
            curr++;
        }else{
            TextView error = new TextView(getApplicationContext());
            error.setText("Please, fill out all of the Fields");
            layouts[curr].addView(error);
        }
    }

    private void grabData() {
        switch(curr){
            case 0:
                sName = name.getText().toString();
                sAge = age.getText().toString();
                sEmail = email.getText().toString();
                creator.setAge(sAge);
                setIncomeLayout();
                break;
            case 1:
                sIncome = income.getText().toString();
                creator.setMonthlyIncome(sIncome);
                setLocationLayout();
                break;
            case 2:
                sLocation = location.getText().toString();
                creator.setLocation(sLocation);
                setHousingLayout();
                break;
            case 3:
                if(rent.isChecked()){
                    sHousingType = "Renting";
                    creator.setHousingOwnership(sHousingType);
                }else if(own.isChecked()){
                    sHousingType ="I own my housing with a mortgage";
                    creator.setHousingOwnership(sHousingType);
                }else{
                    TextView error = new TextView(getApplicationContext());
                    Log.println(Log.WARN, "error", "this selected");
                    error.setText("Internal Error");
                    layouts[curr].addView(error);
                    break;
                }
                sHousingPay = housingPayment.getText().toString();
                creator.setHousingPayment(sHousingPay);
                setsavingsLayout();
                break;
            case 4:
                sSavings = savings.getText().toString();
                sDebts = debts.getText().toString();
                creator.setSavings(sSavings);
                creator.setDebt(sDebts);
                setSecurityLayout();
                break;
            case 5:
                pin.getText().toString();
                setVerifyLayout();
                break;
            default:
                TextView error = findViewById(R.id.errorText);
                error.setText("There is an internal error");
                layouts[curr].addView(error);
                break;
        }
    }

    private void submitData() {
        Intent changescene = new Intent(UserInfo.this, MainActivity.class);
        startActivity(changescene);
    }

    private boolean infoFull(LinearLayout layout) {
        boolean boolrg = true;
        boolean boolet = true;
        for(int i =0; i<layout.getChildCount(); i++){
            if(layout.getChildAt(i).isShown()){
                if(layout.getChildAt(i).getClass().equals(RadioGroup.class)){
                    RadioGroup rg = (RadioGroup) layout.getChildAt(i);
                    if(rg.getCheckedRadioButtonId()==-1) boolrg =false;
                }
                if(layout.getChildAt(i).getClass().equals(EditText.class)){
                    EditText et = (EditText) layout.getChildAt(i);
                    if(et.getText().toString().isEmpty()) boolet = false;
                }
            }
        }
        return boolet&&boolrg;
    }

}
