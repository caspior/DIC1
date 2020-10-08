# Get API data:

library(RSocrata)

url <- "https://data.austintexas.gov/resource/7d8e-dm7r.json"
df <- read.socrata(url)


#Pre-cleaning:
#  -less than .1 mile trip distnace.
#-more than 500 mile trip distance.
#-more than 24hr trip drip duration.

# Creating clone:

scooters <- df


# Additional cleaning:

# If exceeds 50 km/h:
scooters$trip_distance <- as.integer(scooters$trip_distance)
scooters$trip_duration <- as.integer(scooters$trip_duration)
scooters$speed <- scooters$trip_distance/scooters$trip_duration*3.6 # (m/s -> km/h)
scooters <- scooters[c(which(scooters$speed<=50)),]
N <- nrow(df)
n <- nrow(scooters)
print(paste("Droped",N-n,"trips"))


# Setting dates:

scooters$Date <- as.character(scooters$start_time)
scooters$Date <- substr(scooters$Date, 1, 10)
scooters$Date <- as.Date(scooters$Date, "%Y-%m-%d")


# Getting COVID Cases data:

urlc <- "https://raw.githubusercontent.com/caspior/DIC1/main/Austin_Covid.csv"
covid <- read.csv(urlc)
covid$Date <- as.Date(covid$Date, "%m/%d/%Y")


# Limit scooters dataset to covide period:

sc <- scooters[which((scooters$Date >= min(covid$Date) & (scooters$Date <= max(covid$Date)))),]


# Adding daily cases to trip data set:

sc <- merge.data.frame(sc,covid, by = "Date")


# Trips per day

library(dplyr)

by_day <- group_by(sc, Date)
by_day <- summarise(by_day, trips = n(), avg_distance = mean(trip_distance), avg_duration = mean(trip_duration), sum_duration = sum(trip_duration), cases = min(Cases))


## Descriptive statistics

# Cases - Trips

library(ggplot2)

ggplot(by_day, aes(x=Date)) +
  geom_line(aes(y=cases, color="red")) +
  geom_line(aes(y=trips, color="blue")) +
  labs(title = "Trips and COVID19-cases per day", x="Date", y="Daily cases") +
  scale_x_date(date_breaks="1 month",date_labels="%b %Y") +
  scale_y_continuous(sec.axis = sec_axis(~.*(max(by_day$cases)/max(by_day$trips)), name="Daily trips"))




library(ggplot2)

ggplot(by_day, aes(x=Date)) +
  geom_line(aes(y=cases/max(cases)), color="red",size=2) +
  geom_line(aes(y=trips/max(trips)), color="blue",size=0.7) +
  labs(title = "Trips and COVID19-cases per day", x="Date", y="Ratio of maximum") +
  scale_x_date(date_breaks="1 month",date_labels="%b %Y")



library(ggplot2)

lm <- lm(by_day$cases~by_day$trips)

ggplot() +
  geom_point(data=by_day,aes(x=cases, y=trips),size=0.7) +
  geom_smooth(method="lm", data=by_day, aes(x=cases, y=trips), color="blue",size=0.7, ) +
  annotate("text", x=max(by_day$cases)/4, y=max(by_day$trips)*0.75, label=paste0("Trips = ",round(lm[["coefficients"]][["(Intercept)"]],2)," + ",round(lm[["coefficients"]][["by_day$trips"]],2)," * Cases")) +
  labs(title = "Trips and COVID19-cases per day", x="Cases", y="Trips")


# Cases - Average Distance

library(ggplot2)

ggplot(by_day, aes(x=Date)) +
  geom_line(aes(y=cases, color="red")) +
  geom_line(aes(y=avg_distance, color="blue")) +
  labs(title = "Average distance and COVID19-cases per day", x="Date", y="Daily cases") +
  scale_x_date(date_breaks="1 month",date_labels="%b %Y") +
  scale_y_continuous(sec.axis = sec_axis(~.*(max(by_day$cases)/max(by_day$avg_distance)), name="Daily average distance (meters)"))




library(ggplot2)

ggplot(by_day, aes(x=Date)) +
  geom_line(aes(y=cases/max(cases)), color="red",size=2) +
  geom_line(aes(y=avg_distance/max(avg_distance)), color="blue",size=0.7) +
  labs(title = "Average distance and COVID19-cases per day", x="Date", y="Ratio of maximum") +
  scale_x_date(date_breaks="1 month",date_labels="%b %Y")



library(ggplot2)

lm <- lm(by_day$cases~by_day$avg_distance)

ggplot() +
  geom_point(data=by_day,aes(x=cases, y=avg_distance),size=0.7) +
  geom_smooth(method="lm", data=by_day, aes(x=cases, y=avg_distance), color="blue",size=0.7, ) +
  annotate("text", x=max(by_day$cases)*0.75, y=max(by_day$avg_distance)*0.75, label=paste0("Average Distance = ",round(lm[["coefficients"]][["(Intercept)"]],2)," ",round(lm[["coefficients"]][["by_day$avg_distance"]],2)," * Cases")) +
  labs(title = "Average Distance and COVID19-cases per day", x="Cases", y="Average Distance")


# Cases - Average Duration

library(ggplot2)

ggplot(by_day, aes(x=Date)) +
  geom_line(aes(y=cases, color="red")) +
  geom_line(aes(y=avg_duration, color="blue")) +
  labs(title = "Average duration and COVID19-cases per day", x="Date", y="Daily cases") +
  scale_x_date(date_breaks="1 month",date_labels="%b %Y") +
  scale_y_continuous(sec.axis = sec_axis(~.*(max(by_day$cases)/max(by_day$avg_duration)), name="Daily Average duration"))




library(ggplot2)

ggplot(by_day, aes(x=Date)) +
  geom_line(aes(y=cases/max(cases)), color="red",size=2) +
  geom_line(aes(y=avg_duration/max(avg_duration)), color="blue",size=0.7) +
  labs(title = "Average duration and COVID19-cases per day", x="Date", y="Ratio of maximum") +
  scale_x_date(date_breaks="1 month",date_labels="%b %Y")



library(ggplot2)

lm <- lm(by_day$cases~by_day$avg_duration)

ggplot() +
  geom_point(data=by_day,aes(x=cases, y=avg_duration),size=0.7) +
  geom_smooth(method="lm", data=by_day, aes(x=cases, y=avg_duration), color="blue",size=0.7, ) +
  annotate("text", x=max(by_day$cases)*0.75, y=max(by_day$avg_duration)*0.90, label=paste0("Average Duration = ",round(lm[["coefficients"]][["(Intercept)"]],2)," + ",round(lm[["coefficients"]][["by_day$avg_duration"]],2)," * Cases")) +
  labs(title = "Average Duration and COVID19-cases per day", x="Cases", y="Average Duration")


# Cases - Total Duration

library(ggplot2)

ggplot(by_day, aes(x=Date)) +
  geom_line(aes(y=cases, color="red")) +
  geom_line(aes(y=sum_duration/3600, color="blue")) +
  labs(title = "sum_duration and COVID19-cases per day", x="Date", y="Daily cases") +
  scale_x_date(date_breaks="1 month",date_labels="%b %Y") +
  scale_y_continuous(sec.axis = sec_axis(~.*(max(by_day$cases)/max(by_day$sum_duration)), name="Daily total duration (hours)")) +
  labs(title = "Total Duration and COVID19-cases per day", x="Cases", y="Total Duration")



library(ggplot2)

ggplot(by_day, aes(x=Date)) +
  geom_line(aes(y=cases/max(cases)), color="red",size=2) +
  geom_line(aes(y=sum_duration/max(sum_duration)), color="blue",size=0.7) +
  labs(title = "Total duration and COVID19-cases per day", x="Date", y="Ratio of maximum") +
  scale_x_date(date_breaks="1 month",date_labels="%b %Y")



library(ggplot2)

lm <- lm(by_day$cases~by_day$sum_duration)

ggplot() +
  geom_point(data=by_day,aes(x=cases, y=sum_duration),size=0.7) +
  geom_smooth(method="lm", data=by_day, aes(x=cases, y=sum_duration), color="blue",size=0.7, ) +
  annotate("text", x=max(by_day$cases)*0.75, y=max(by_day$sum_duration)*0.75, label=paste0("Total Duration = ",round(lm[["coefficients"]][["(Intercept)"]],2)," + ",round(lm[["coefficients"]][["by_day$sum_duration"]],4)," * Cases")) +
  labs(title = "Total Duration and COVID19-cases per day", x="Cases", y="Total Duration")
