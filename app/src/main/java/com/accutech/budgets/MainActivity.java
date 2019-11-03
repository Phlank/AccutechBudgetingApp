package com.accutech.budgets;

import androidx.appcompat.app.AppCompatActivity;
import android.graphics.Color;
import android.os.Bundle;
import java.util.ArrayList;
import lecho.lib.hellocharts.model.PieChartData;
import lecho.lib.hellocharts.model.SliceValue;
import lecho.lib.hellocharts.view.PieChartView;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        PieChartView pieChartView = findViewById(R.id.BudgetOverviewChart);
        ArrayList<SliceValue> pieData = new ArrayList<>();
        /*
            below this is where the data for the pie chart goes
            slice value is the individual slice of pie
            probably should go with brighter colors so if we make a list of colors from happiest to least
            that would work here
         */
        pieData.add(new SliceValue(15, Color.BLUE));
        pieData.add(new SliceValue(90, Color.GRAY));
        pieData.add(new SliceValue(10, Color.RED));
        pieData.add(new SliceValue(60, Color.MAGENTA));
        PieChartData pieChartData = new PieChartData(pieData);
        pieChartView.setPieChartData(pieChartData);
        setContentView(R.layout.activity_main);
    }
}
