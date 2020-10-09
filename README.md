# Data Incubator Challange section 1
### Research project by Or Caspi.

This project examines the effect of COVID-19 on scooter sharing usage in Austin, Texas.
At its prime days, COVID-19 was considered to be highly contagious thru surfaces, and using a shared scooter or bicycle conceived as a risk. In addition, Texas entered into lockdown on March 19th, reducing the number of potential trips.
During May, Texas has started to reopen. However, people still avoided open space and public transportation. The scooter companies increased their attention to sanitizing their vehicles in the hope of convincing users that the scooter sharing is safe.
In this study, I examine whether scooter usage decrease increased or did not affect by COVID-19. More importantly, I specifically examine how the total usage duration has changed, as the scooter payment model is based on each ride's time. 

The data is based on two sources:
1. [Austin's micromobility trip logs](https://data.austintexas.gov/Transportation-and-Mobility/Dockless-Vehicle-Trips/7d8e-dm7r)
2. [Texas's COVID-19 daily cases by county](https://dshs.texas.gov/coronavirus/additionaldata.aspx)

The data was analyzed using R Studio. The full script can be found [here](https://github.com/caspior/DIC1/blob/main/Section1.Rmd).
Preliminary results that include descriptive statistics can be found [here](https://htmlpreview.github.io/?https://raw.githubusercontent.com/caspior/DIC1/main/Section1.html).

The diagrams show that scooter ridership decreased and almost stopped in March but increased in May as COVID cases in Austin went up. The overall effect of COVID on the number of trips is positive. Findings regarding trip distance and duration show that each trip's average distance decreased with COVID, but the average duration did not change significantly. With that, the increase of ridership results in a total rise in usage duration and, therefore, an increase in the scooter's revenue.

In the Spatial analysis, I subtracted the number of trips done between March to July 2020 from the number of trips done between August and October 2020.
The map shows that trips increased in and around central Austin while its periphery saw a reduction in ridership. This finding corresponds to the decline in the average trip distance due to COVID. Hence, users ride shorter trips in the city center and not in the periphery.

This study will include the following analyses:
- Comparison of usage between March - December 2020 to March - December 2019 in order to control for seasonality.
- Spatial analysis to examine the change in trip origin-destination patterns due to COVID.
- A combination of random forest analysis and time series regression analysis with control variables such as weather, day of the week, and holidays.
- Comparison to bikesharing usage, transit usage, and car ridership during the same period.
