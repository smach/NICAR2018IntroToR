# NICAR 2018 Intro to R and RStudio
# Sharon Machlis

# Here's the part where we analyze a data set and I explain what's going on.


# The data file is a CSV of Chicago municipal salary data.
# We are going to use the rio package's "import" function to import the file into an R variable called mydata.

# What's that <- symbol? It means "assign the value of what's on the right to the variable on the left."
# In most cases, you can use an = sign as well. But in certain cases, <- is needed.
# Most R users these days use <-, but if bugs the heck out of you, switch to = for this session so it doesn't distract you.

mydata <- rio::import("data/Current_Employee_Names__Salaries__and_Position_Titles.csv")

# Let's examine the first and last rows of this data, now in the mydata variable
head(mydata)
tail(mydata)

# R column names shouldn't really have spaces in them. The janitor package's clean_names function will take care of this for us.
mydata <- janitor::clean_names(mydata)

# Let's look at how the data is structured.
str(mydata)


# Uh oh, salary values came in as characters and not numbers, because R didn't understand that the dollar sign and commas in the CSV file signified currency. Fortunately, I wrote a function in my rmiscutils package that fixes this. And you can use it too :-) It's called number_with_commas

# Note: There are 2 ways to use a function in an external R package. One is the format we used with rio, which is packageName::functionName(). That just uses the specific function from that package, but doesn't load the whole package with all its other functions into your system's working memory.

# The other way is to load the whole package into memory with library(). That lets you use any of the functions without having to use the packageName:: part. Let's try that with rmiscutils.


library(rmiscutils)

# I'm going to create 2 new columns that turn those character columns into numbers:

mydata$salary <- number_with_commas(mydata$annual_salary)
mydata$hourly <- number_with_commas(mydata$hourly_rate)

# What's with the dollar signs? mydata is a "data frame" -- a 2-dimensional data format with rows and columns, similar in some ways to a spreadsheet. The dollar sign is how R refers to a column.

# Another way to do this, very popular with journalists - Hadley Wickham's "tidyverse" taught here Thursday

library(dplyr)
mydata <- mydata %>%
  mutate(
    salary = number_with_commas(annual_salary),
    hourly = number_with_commas(hourly_rate)
  )

# "mutate" means "change the data frame by adding new columns. The code above says
# "I want to assign the mydata variable the value of the existing mydata variable, with these changes: add a salary column that applies the number_with_commas function to annual_salary, and the same with hourly." It would be the same as creating a new column in Excel and then putting a formula in one of the cells using the value of an existing cell.

# It's good practice not to destroy existing data when making changes. But now that we're sure the changes are OK, we can get rid of the old annual_salary and hourly_rate character columns by selecting them with a minus sign before them:

mydata <- select(mydata, -hourly_rate, -annual_salary)

# That %>% collection of characters is a "pipe." It just means "take the result of what happened and pipe it into the next set of commands." 

# In the first code block, I had to repeat the name of the data frame, mydata, in every part of the code. In the dplyr code, after using the name of the data frame in the first line, dplyr understands that's the value for the rest, and you don't have to keep writing mydata$salary and mydata$annual_salary, etc. One of the many reasons so many of us love dplyr.



str(mydata)

# What if we want to see just police data? Let's filter the data to take a subset with all rows where the department column equals POLICE. When you check "does department equal POLICE?" you need double equals signs, not single. (department = "POLICE" says "the value of department equals POLICE." department == "POLICE" tests whether department equals POLICE. This is common in many programming languages, not just R)

police <- filter(mydata, department == "POLICE")


# Now let's create an interactive HTML table of the police data with one line of code
DT::datatable(police)

# Want search/filter boxes for each column?
DT::datatable(police, filter = 'top')

# Would you like to save this table as an HTML page to post on the Web somewhere? Save the table to an R variable -- in this case mytable -- and then use the htmlwidgets package's saveWidget function to save the table to a self-contained HTML page.

mytable <- DT::datatable(police, filter = 'top')
htmlwidgets::saveWidget(mytable, "police_salaries.html")

# Some more data exploration

# How many full time vs part time are there? Base R's table function on the full_or_part_time column tells us
table(mydata$full_or_part_time)

# Would be kind of annoying to have to run a function manually on each column. There are functions specifically designed to summarize data sets. In base R, it's summary:

summary(mydata)

# A few other favorites:
Hmisc::describe(mydata)
skimr::skim(mydata)

# Visualizing can help see distributions. One way is a histogram
hist(mydata$typical_hours)
hist(mydata$salary)
hist(mydata$hourly)

# Average & Median Full-Time Salaries BY DEPARTMENT: filter for full-time, group by department, then summarize. na.rm means remove the entries that aren't available. R by default wants to make sure that you know there are missing values. The average of 6, 8, and not available could conceivably be anything, if "not available" actually exists but isn't in your data set.

by_department <- mydata %>%
 filter(full_or_part_time == "F") %>%
  group_by(department) %>%
  summarise(
    Average_Salary = mean(salary, na.rm = TRUE),
    Median_Salary = median(salary, na.rm = TRUE)
  )



# If you need to get rid of scientific notation:
options(scipen = 999)
hist(by_department$Average_Salary)

# Visualize distribution for salaried employees by department - box plots are another way to do this
salaried_employees <- mydata %>%
  filter(salary_or_hourly == "Salary")

boxplot(salary ~ department, data = salaried_employees)

# How to read a box plot? The line is the median -- half values are higher, half lower. Top and bottom of the box are upper & lower quartiles -- upper is 25%, lower is 75%. The "whiskers" represent what are considered non-outlier high and low values. The default calculation for whiskers is 1.5 times the difference between the 75% level and the 25% level, known in stats speak as the "interquartile range."

# Not the easiest to read. 



library(ggplot2)



# Well-known plotting library in R ggplot2. Sorry don't have enough time to explain the all details, but first line says what the data should be. data = mydataframe, aes stands for aesthetics, and what the x and y should be. This just defines data parameters. Next line says what type of graph it should be, in this case a box plot using the geom_boxplot() function. Last line flips the coordinates.

ggplot(data = salaried_employees, aes(x=department, y = salary)) +
  geom_boxplot() +
  coord_flip()

# Easy way to add JavaScript roll-over functions?

library(plotly)


ggplotly(
  
  ggplot(data = salaried_employees, aes(x=department, y = salary)) +
    geom_boxplot() +
    coord_flip() 
  
)



# highest median salaries? bar chart

ggplot(data = by_department, aes(x = department, y = Median_Salary)) +
  geom_col()

# Hard to read that x axis, we'll get to that

# If you wanted the bars ordered from largest to smallest
ggplot(data = by_department, aes(x = reorder(department, -Median_Salary), y = Median_Salary)) +
  geom_col()

# Still impossible to read the x axis. Let's get to that. Not intuitive, but I save this theme() snippet for reuse.

ggplot(data = by_department, aes(x = reorder(department, -Median_Salary), y = Median_Salary)) +
  geom_col() +
  theme(axis.text.x = element_text(angle = 90, vjust = 1.2, hjust = 1.1))
  
# Make all the bars blue (back to alphabetical order)
ggplot(data = by_department, aes(x = department, y = Median_Salary)) +
  geom_col(fill="blue") +
  theme(axis.text.x = element_text(angle = 90, vjust = 1.2, hjust = 1.1))


# Get rid of the trademark grid background, add a title, add commas to y axis
library(scales)

ggplot(data = by_department, aes(x = department, y = Median_Salary)) +
  geom_col(fill="blue") +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 90, vjust = .2, hjust = 1.0)) +
  xlab("Department") +
  ylab("") +
  scale_y_continuous(label=comma) +
  ggtitle("Chicago Full-Time Workers' Median Salaries")

# plotly works here as well, but I prefer the rcdimple package for bar charts:


library(rcdimple)

by_department %>% 
dimple(x = "department", y = "Median_Salary", type = "bar") %>%
add_title("Chicago Full-Time Workers' Median Salaries") %>%
default_colors(c("#0072B2"))

# dimple() is the graphing function. It only does bar, line, area, or bubble charts.

figure(ylab = "Salary", width = 1000) %>%
  ly_boxplot(department, salary, data = salaried_employees, hover = c(department, salary))

# How do I keep all these packages and functions straight? I write code snippets in RStudio and then re-use them.

# More info at https://support.rstudio.com/hc/en-us/articles/204463668-Code-Snippets

# Gallery of HTML widgets: http://gallery.htmlwidgets.org/
# I play around with them and decide if I want to add any to my toolset.

highcharter::hcboxplot(x = salaried_employees$salary, var = salaried_employees$department,
          name = "Salary", color = "#2980b9") 




# The rest of this code is "if in case we finish early and I want to show more." But I'm not prepared to explain this as a hands-on, just demo. 

# It's possible to separate the name columns, and then use some R packages to do a rough estimate of salaries by gender. Unfortunately, the data doesn't include either gender information or years of service, both of which would be needed to have a dependable analysis. THIS IS EXPLORATORY ONLY to see if more investigation might be warranted.

library(tidyr)

# Separate the name field
mydata <- separate(mydata, name, into=c("Last", "First"), sep = ", ")
mydata$First <- trimws(mydata$First)
mydata <- separate(mydata, First, into=c("First", "Middle"), sep = " ")

# Use a gender package that tries to guess gender by name, in this case using the Social Security data base. For obvious reasons, this is an imperfect method.
library(gender)
the_genders <- gender(names = mydata$First, method = "ssa", countries = "United States")

gender_lookup <- the_genders$gender
names(gender_lookup) <- the_genders$name
mydata$Gender <- gender_lookup[mydata$First]  

# How easy it is to create crosstabs
library(janitor)
gender_pct <- mydata %>%
  crosstab(department, Gender, percent = "row")

# Look at salaries by percent females 
gender_info <- merge(gender_pct, by_department[,c("department", "Median_Salary")], by.x = "department", by.y = "department") %>%
  arrange(female)

gender_info

ggplot(data = gender_info, aes(x = female, y = Median_Salary)) +
  geom_point() +
  geom_smooth(method='lm')

ggplot(data = gender_info, aes(x = female, y = Median_Salary)) +
  geom_point() +
  geom_smooth()

# Looking at correlation tests
cor(gender_info$female, gender_info$Median_Salary)

cor.test(gender_info$female, gender_info$Median_Salary)

# Police department
police_summaries <- mydata %>%
  filter(department == "POLICE", salary_or_hourly == "Salary") %>%
  group_by(Gender) %>%
  summarise(
    AverageSalary = mean(salary),
    MedianSalary = median(salary)
  )

police_summaries

police_by_gender <- mydata %>%
  filter(department == "POLICE", salary_or_hourly == "Salary", Gender %in% c("female", "male"))
  
ggplot(data = police_by_gender, aes(x=Gender, y = salary)) +
  geom_boxplot()


# Fire department

fire_by_gender <- mydata %>%
  filter(department == "FIRE", salary_or_hourly == "Salary", Gender %in% c("female", "male"))

ggplot(data = fire_by_gender, aes(x=Gender, y = salary)) +
  geom_boxplot()

# Streets & Sanitation
pw <- mydata %>%
  filter(department == "STREETS & SAN", salary_or_hourly == "Salary", Gender %in% c("female", "male"))

ggplot(data = pw, aes(x=Gender, y = salary)) +
  geom_boxplot()




