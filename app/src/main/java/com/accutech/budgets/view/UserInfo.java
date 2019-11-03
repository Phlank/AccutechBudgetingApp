package com.accutech.budgets.view;

import androidx.appcompat.app.AppCompatActivity;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.RadioButton;
import android.widget.TextView;

import com.accutech.budgets.MainActivity;
import com.accutech.budgets.R;

public class UserInfo extends AppCompatActivity {



    private EditText pin, location, name, email, income, age, dependents, housingPayment;
    private RadioButton own, rent;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_user_info);
        pin = findViewById(R.id.pin);
        location = findViewById(R.id.location);
        name = findViewById(R.id.name);
        email = findViewById(R.id.email);
        income = findViewById(R.id.income);
        age = findViewById(R.id.age);
        dependents = findViewById(R.id.dependents);
        housingPayment = findViewById(R.id.payment);
        own = findViewById(R.id.Own);
        rent = findViewById(R.id.rent);

        Button submit = findViewById(R.id.submitData);

        submit.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                submitData();
            }
        });


    }

    @SuppressLint("SetTextI18n")
    private void submitData() {
        if(pin.getText().toString().isEmpty()||location.getText().toString().isEmpty()||
                name.getText().toString().isEmpty()||email.getText().toString().isEmpty()||
                income.getText().toString().isEmpty()||age.getText().toString().isEmpty()||
                dependents.getText().toString().isEmpty()||housingPayment.getText().toString().isEmpty()){
            TextView error = findViewById(R.id.dataErrorText);
            error.setText("Please, fill out all of the Fields");
        }else{
            Intent changescene = new Intent(UserInfo.this, MainActivity.class);
            startActivity(changescene);
        }

    }
}
