Developing_Product
==================

Project for course Developing Data Product

You can find below a brief description of shiny app:

The purpose of this simple app is to show the number of injuries / fatalities between years 2000 to 2010.

To do this, I have used the NOAA dataSet and filter the information between years 2000 and 2010.

The screen is divided in two different parts:

* Criteria: where you can put the inputs.

The following inputs can be put:

1. Latitude and Longitude. You can put here the latitude and longitude of a location (in radians). This locations will be used as base to obtain the closer events. The location is Los Angeles by defect. All what you have to do is find the latitude and longitud for a location in the map and put them on these two fields.
2. Dates. A period of date for what the injuries and fatalities will be taken into account.
3. Radius. Only those events which have happened in a location closer to location this number of kilometers will be taken into account.

* Results:

1. A graph were you can see the years in the x axis and number of fatalities / injuries in y axis is shown. You can see also a small prediction based in a linear model.
2. A summary with the figures per year.

To obtain the closer point to a location, a specific function was created to obtain the distance between two points on the earth considering that earch is a circunference.
