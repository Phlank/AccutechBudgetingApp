package com.accutech.budgets;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

public class LoginActivity extends AppCompatActivity {

    private EditText pin;
    private TextView error;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);
        this.pin = findViewById(R.id.pinEntry);
        error = findViewById(R.id.errorText);
        Button submit = findViewById(R.id.button);
        Button newUser = findViewById(R.id.newUser);
        submit.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                onLogin();
            }
        });
        newUser.setOnClickListener(new View.OnClickListener(){

            @Override
            public void onClick(View v) {
                Intent user = new Intent(LoginActivity.this,UserInfo.class);
                startActivity(user);
            }
        });
    }

    private void onLogin(){
        if (pin.getText().toString().equals("1234")) {
            Intent success = new Intent(LoginActivity.this, MainActivity.class);
            startActivity(success);
        }else{
            error.setText("Wrong PIN, try again");
            error.setTextSize(25);
            error.setTextColor(Color.RED);
        }
    }
}
