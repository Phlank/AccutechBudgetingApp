package com.accutech.budgets.view;

import android.graphics.Color;
import android.os.Bundle;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;
import com.accutech.budgets.R;
import com.accutech.budgets.model.Budget;
import com.accutech.budgets.model.BudgetCategory;
import com.accutech.budgets.model.BudgetCreator;
import java.util.ArrayList;
import lecho.lib.hellocharts.model.PieChartData;
import lecho.lib.hellocharts.model.SliceValue;
import lecho.lib.hellocharts.view.PieChartView;

public class MainActivity extends AppCompatActivity {

    private BudgetCreator bc = new BudgetCreator();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Budget mainBudget = bc.createBudget();

        double housing = mainBudget.getAllotment(BudgetCategory.HOUSING);
        double utilities = mainBudget.getAllotment(BudgetCategory.UTILITIES);
        double groceries = mainBudget.getAllotment(BudgetCategory.UTILITIES);
        double savings = mainBudget.getAllotment(BudgetCategory.UTILITIES);
        double health = mainBudget.getAllotment(BudgetCategory.UTILITIES);
        double transportation = mainBudget.getAllotment(BudgetCategory.UTILITIES);
        double education = mainBudget.getAllotment(BudgetCategory.UTILITIES);
        double entertainment = mainBudget.getAllotment(BudgetCategory.UTILITIES);
        double kids = mainBudget.getAllotment(BudgetCategory.UTILITIES);
        double pets = mainBudget.getAllotment(BudgetCategory.UTILITIES);
        double misc = mainBudget.getAllotment(BudgetCategory.UTILITIES);

        PieChartView pieChartView = findViewById(R.id.BudgetOverviewChart);
        ArrayList<SliceValue> pieData = new ArrayList<>();
        pieData.add(new SliceValue((float) housing, Color.rgb(128,0,0)));
        pieData.add(new SliceValue((float) utilities, Color.rgb(94,25,20)));
        pieData.add(new SliceValue((float) groceries, Color.rgb(124,10,2)));
        pieData.add(new SliceValue((float) savings, Color.rgb(11, 102, 35)));
        pieData.add(new SliceValue((float) health, Color.rgb(255,8,0)));
        pieData.add(new SliceValue((float) transportation, Color.rgb(141,2,31)));
        pieData.add(new SliceValue((float) education, Color.rgb(184,15,40)));
        pieData.add(new SliceValue((float) entertainment, Color.rgb(115,194,251)));
        pieData.add(new SliceValue((float) kids, Color.rgb(17,30,108)));
        pieData.add(new SliceValue((float) pets, Color.rgb(0,128,255)));
        pieData.add(new SliceValue((float) misc, Color.YELLOW));
        PieChartData pieChartData = new PieChartData(pieData);
        pieChartView.setPieChartData(pieChartData);
        pieChartView.setChartRotationEnabled(true);


    }

}
