#Loading the data 
load("lead.RData")
install.packages("car")
library(car)
myData<-lead
# 1.Descriptive statistics for numeric variables
# str(myData)
# Summary about the data --> mean, median, minimum, maximum, first and third quartile 
summary(myData)

#Another way to calculate mean,median,minimum,maximum,first and third quartile --> Weight
#myData$weight<- as.numeric(myData$weight,na.rm=TRUE)
mean(myData$MAXFWT,na.rm=TRUE)
median(myData$MAXFWT,na.rm=TRUE)
min(myData$MAXFWT,na.rm=TRUE)
max(myData$MAXFWT,na.rm=TRUE)
quantile(myData$MAXFWT,na.rm=TRUE,0.25)
quantile(myData$MAXFWT,na.rm=TRUE,0.75)

# Extract unique values 
unique(myData$Exposed)
unique(myData$Sex)

myData$Lead_type <- factor(myData$Lead_type)
myData$Sex <- factor(myData$Sex)
myData$Lead_type<-factor(myData$Lead_type,labels=c("Lead_type1","Lead_type2"))

# Frequency table for categorical variable
table(myData$Sex)
table(myData$Exposed)
table(myData$Lead_type)
table(myData$Area)


# Calculate correlation coefficient between MAXWT and Ld72
cor(myData$MAXFWT, myData$Ld72, use = "complete.obs")
cor(myData$MAXFWT, myData$Ld72) #Na

# Calculate correlation coefficient between MAXWT and Ld73
cor(myData$MAXFWT, myData$Ld73, use = "complete.obs") 
cor(myData$MAXFWT, myData$Ld73) #Na

#Sex --> Male & Female instead of 0 & 1
levels(myData$Sex)=c("Male","Female")
myData$Sex<-factor(myData$Sex,labels=c("Male","Female"))
#Lead type 1&2 instead of 1&2
myData$Lead_type<-factor(myData$Lead_type,labels=c("Lead_type1","Lead_type2"))
########################################################################################

# 2 Graphics
# Bar chart of gender
barplot(table(myData$Sex), xlab = "Gender", ylab = "Frequency", main = "Gender Distribution",col="#a6d4e0")
#From the distribution here --> Female < Male (far)

# Calculate mean MAXWT by gender
means <- aggregate(MAXFWT ~ Sex, myData, mean)

# Bar chart of mean MAXWT by gender
barplot(means$MAXFWT, names.arg = means$Sex, xlab = "Gender", ylab = "Mean MAXWT", main = "Mean MAXWT by Gender",col="#a6d4e0")
#From the distribution here due to mean --> Female > Male (near)

# Histogram of the continuous variable "Age"
hist(myData$Age, main = "Age Distribution", xlab = "Age", ylab = "Frequency",col="#e5beeb")
#From the distribution here --> seems to be NOT normally distributed (Right Skewed)
mean_age <- mean(myData$Age) # 9.053922
median_age <- median(myData$Age) # 8.666667

# Histogram of the continuous variable "MAXWT"
hist(myData$MAXFWT, main = "MAXWT Distribution", xlab = "MAXWT", ylab = "Frequency",col="#e5beeb")
#From the distribution here -->  seems to be NOT normally distributed  (Right Skewed)
mean(myData$MAXFWT,na.rm=TRUE) # 52.048
median(myData$MAXFWT,na.rm=TRUE) # 52

# Make a scatterplot of 2 continuous variables Ld72 and MAXWT, and add the regression lines for each gender
plot(myData$Ld72,myData$MAXFWT,xlab="Ld72",ylab="MAXFWT",main="Scatterplot Of Ld72 and MAXFWT",col="#9c560c")
abline(lm(MAXFWT ~ Ld72, data = subset(myData, Sex == "Male")), col ="#0983b8")
abline(lm(MAXFWT ~ Ld72, data = subset(myData, Sex == "Female")), col = "#a30b82")
# Negative Relation 

# Boxplot of Age
boxplot(myData$Age, main = "Age Distribution", ylab = "Age",col="#e5beeb") # No outliers # Variability 

# Boxplot of Age for Ld72
boxplot(myData$Age ~ as.factor(myData$Ld72), main = "Age Distribution by Ld72", xlab = "Ld72", ylab = "Age",col="#e5beeb")
boxplot(myData$Age ~ cut(myData$Ld72,4), main = "Age Distribution by Ld72", xlab = "Ld72", ylab = "Age",col="#a6d4e0")

# Boxplot of Age for Ld73
boxplot(myData$Age ~ as.factor(myData$Ld73), main = "Age Distribution by Ld73", xlab = "Ld73", ylab = "Age",col="#e5beeb")
boxplot(myData$Age ~ cut(myData$Ld73,4), main = "Age Distribution by Ld73", xlab = "Ld73", ylab = "Age",col="#a6d4e0")
##################################################################################

# 3 Outliers
#Exploring the data for any existing outliers
#MAXFWT
boxplot(myData$MAXFWT, main = "MAXFWT", ylab = "MAXFWT",col="#cba4ed")
outliers <- boxplot.stats(myData$MAXFWT)$out
outliers

#Ld72
boxplot(myData$Ld72, main = "Ld72", ylab = "Ld72",col="#cba4ed")
outlier2 <- boxplot.stats(myData$Ld72)$out
outlier2

#Ld73
boxplot(myData$Ld73, main = "Ld73", ylab = "Ld73",col='#cba4ed')
outlier3 <- boxplot.stats(myData$Ld73)$out
outlier3

#MAXFWT --> Male
boxplot(myData[myData$Sex == "Male",]$MAXFWT, main = "MAXFWT_male", ylab = "MAXFWT",col="#cba4ed")
outlier4 <- boxplot.stats(myData[myData$Sex == "Male",]$MAXFWT)$out
outlier4

#MAXFWT --> Female
boxplot(myData[myData$Sex == "Female",]$MAXFWT, main = "MAXFWT_Female", ylab = "MAXFWT",col="#cba4ed")
outlier5 <- boxplot.stats(myData[myData$Sex == "Female",]$MAXFWT)$out
outlier5

boxplot(myData$Age, main = "Age",col="#cba4ed")
outlier6 <- boxplot.stats(myData$Age)$out
outlier6

#There are some outliers in some of variables 
######################################################################################

# 4.Testing for normality

# First --> Histograms
hist(myData$Age, main="Histogram of Age", xlab="Age",col="#edb4e5") #Right Skewed 
hist(myData$MAXFWT, main="Histogram of MAXFWT", xlab="MAXFWT",col="#edb4e5") #Right Skewed 
hist(myData[myData$Sex == "Male",]$MAXFWT, main='Males MAXFWT',xlab="Males",col="#edb4e5") 
hist(myData[myData$Sex == "Female",]$MAXFWT, main='Female MAXFWT',xlab="Females",col="#edb4e5") 
hist(myData$Ld72, main="Histogram of Ld72", xlab="Ld72",col="#edb4e5")  #Right Skewed 
hist(myData$Ld73, main="Histogram of Ld73", xlab="Ld73",col="#edb4e5") #Right Skewed 
#hist(myData$Totyrs, main="Histogram of Totyrs", xlab="Totyrs",col="#edb4e5")

# Q-Q plot
# MAXFWT - Male
qqnorm(myData[myData$Sex == "Male",]$MAXFWT,col="orange",main="QQ-Plot for MAXFWT - Male") 
qqline(myData[myData$Sex == "Male",]$MAXFWT,col= "purple",lwd=2) 
# Not Normal 

# MAXFWT - Female"
qqnorm(myData[myData$Sex == "Female",]$MAXFWT,col="orange",main="QQ-Plot for MAXFWT - Female") 
qqline(myData[myData$Sex == "Female",]$MAXFWT,col= "purple",lwd=2)
# Normal 

# MAXFWT 
qqnorm(myData$MAXFWT,col="orange",main="QQ-Plot for MAXFWT ")
qqline(myData$MAXFWT,col= "purple",lwd=2)
# Not Normal 

#Ld72
qqnorm(myData$Ld72,col="orange",main="QQ-Plot for Ld72")
qqline(myData$Ld72,col= "purple",lwd=2)
# Not Normal 

#Ld73
qqnorm(myData$Ld73,col="orange",main="QQ-Plot for Ld73")
qqline(myData$Ld73,col= "purple",lwd=2)
# Not Normal 

#Method 2 using Shapiro test : We will set that 
# Null: The data is Normally distributed --> p-val > 0.05
# Alternative: The data is Not Normally distributed --> p-val < 0.05
shapiro.test(myData$Age) # Age -->Not normalized 
shapiro.test(myData$MAXFWT)# MAXFWT --> Not normalized 
shapiro.test(myData[myData$Sex == "Male",]$MAXFWT)    #  Male --> Not normalized 
shapiro.test(myData[myData$Sex == "Female",]$MAXFWT)  #  Female --> normalized 
shapiro.test(myData$Ld72)# Ld72 --> Not normalized 
shapiro.test(myData$Ld73)# Ld73 --> Not normalized 



# Checking homoscedasticity (p-value  > 0.05)
# Null : The data is equal variance 
# Alternative : The data is Not equal variance 

# To visualize 
boxplot(MAXFWT~Sex,data=myData,col="#aecad1",main="Boxplot MAXFWT (Male & Female")
boxplot(Age~Sex,data=myData,col="#aecad1",main="Boxplot Age (Male & Female")    
boxplot(Ld72~Sex,data=myData,col="#aecad1",main="Boxplot Ld72 (Male & Female)") 
boxplot(Ld73~Sex,data=myData,col="#aecad1",main="Boxplot Ld73 (Male & Female)") 

#Levene Test 
leveneTest(Age~Sex,data=myData)# Age --> equal variance
leveneTest(MAXFWT~Sex,data=myData)# MAXFWT --> equal variance
leveneTest(Ld72~Sex,data=myData)# Ld72 --> equal variance
leveneTest(Ld73~Sex,data=myData)# Ld73 --> equal variance

#2 : bartlett test : only data --> normally distributed 
bartlett.test(myData$MAXFWT ~ myData$Sex)
#bartlett.test(myData$Ld72 ~ myData$Sex)
#bartlett.test(myData$Ld73 ~ myData$Sex)
####################################################################################

# 5.Statistical Inference 
#First Method using Confint
model_male <- lm(MAXFWT ~ 1, data = myData[myData$Sex == "Male", ])
model_female <- lm(MAXFWT ~ 1, data = myData[myData$Sex == "Female", ])
# Calculate confidence intervals for males
ci_male_90 <- confint(model_male, level = 0.90)
ci_male_95 <- confint(model_male, level = 0.95)
ci_male_99 <- confint(model_male, level = 0.99)
# Calculate confidence intervals for Females
ci_female_90 <- confint(model_female, level = 0.90)
ci_female_95 <- confint(model_female, level = 0.95)
ci_female_99 <- confint(model_female, level = 0.99)

# Using t-test
t.test(myData$MAXFWT[myData$Sex == "Male"], conf.level = 0.90) #  47.19258 : 54.16742
t.test(myData$MAXFWT[myData$Sex == "Female"], conf.level = 0.90)  # 51.36321 56.87921
t.test(myData$MAXFWT[myData$Sex == "Male"], conf.level = 0.95) # 46.49985 : 54.86015
t.test(myData$MAXFWT[myData$Sex == "Female"], conf.level = 0.95) # 50.80466 : 57.43776
t.test(myData$MAXFWT[myData$Sex == "Male"], conf.level = 0.99) # 45.10538 : 56.25462
t.test(myData$MAXFWT[myData$Sex == "Female"], conf.level = 0.99) # 49.66240 : 58.58003

#####################################################################################

# 6 : Hypothesis Testing :1

#Research question --> Does the MAXWT is different between male & female ?
# Then we will convert to statistical question : Does the mean of female group differs from the mean of male group in MAXWT?
# Null hypothesis : No difference between male & female groups (the 2 groups).
# Alternative hypothesis : There is a difference between male & female groups (the 2 groups).

# using t-test
t.test(MAXFWT~Sex, data=myData,var.equal=TRUE) #P-value --> 0.2364 > 0.05
# So , we do not have enough evidence to reject the null --> MAXFWT is not different.

#Normality for females 
hist(myData[myData$Sex == "Female",]$MAXFWT, main='Female MAXFWT',xlab="Females",col="#d5b2f7") 
shapiro.test(myData[myData$Sex == "Female",]$MAXFWT)  #  Female --> normalized 
qqnorm(myData[myData$Sex == "Female",]$MAXFWT,col="#462d5e") 
qqline(myData[myData$Sex == "Female",]$MAXFWT,col= "#9d9ff2",lwd=2)

#Normality for males 
hist(myData[myData$Sex == "Male",]$MAXFWT, main='Male MAXFWT',xlab="Males",col="#d5b2f7") 
shapiro.test(myData[myData$Sex == "Male",]$MAXFWT)  #  Male --> Not normalized 
qqnorm(myData[myData$Sex == "Male",]$MAXFWT,col="#462d5e") 
qqline(myData[myData$Sex == "Male",]$MAXFWT,col= "#9d9ff2",lwd=2)

# In female --> we do not have enough evidence to reject null --> normal
# In male --> We have enough evidence to reject null --> not normal 

# Variance 
leveneTest(MAXFWT~Sex,data=myData)# MAXFWT --> equal variance
#p-value --> 0.1778 > 0.05 --> we do not have enough evidence to reject null 

# We find that the data is not normal & homoscedasticity --> Not all Assumptions --> met (wilcox test)
# p-value --> 0.1399 > 0.05 --> we do not have enough evidence to reject null --> MAXFWT is not different.
# non-parametric test used to compare the distributions of two independent groups.It is used when the data do not meet the assumptions required for parametric tests, such as the t-test.
wilcox.test(MAXFWT~Sex ,data=myData) 

#              --------------------------------------------------------
#2:
# Does MAXFWT is lower in the receiving group Ld72 >40 compared to the control Ld72 <= 40
# Does the mean of the receiving group Ld72 >40 lower than the mean of the group Ld72 <=40?
# Null : MAXFWT is NOT  lower in receiving group compared to the control Ld72 <= 40
# Alternative : MAXFWT is lower in receiving group compared to the control Ld72 <= 40

wilcox.test(myData[myData$Ld72 > 40,]$MAXFWT,myData[myData$Ld72 <= 40,]$MAXFWT)
#P-value --> 0.003036 < 0.05 --> We have enough evidence to reject null
# We have enough evidence --> receiving group >40 is LOWER than control group <=40

####################### Assess the test assumption : 

#Normality Receiving:
hist(myData[myData$Ld72 > 40 ,]$MAXFWT,col="#95dbed",main="Receiving") # Not normal
qqnorm(myData[myData$Ld72 > 40,]$MAXFWT,col="#9c560c")
qqline(myData[myData$Ld72 > 40,]$MAXFWT,col="#a34b70")
shapiro.test(myData[myData$Ld72 > 40,]$MAXFWT)  # 0.005391 < 0.05
# We have enough evidence to reject null --> NOT Normal

#Normality Controlling:
hist(myData[myData$Ld72 <= 40 ,]$MAXFWT,col="#95dbed",main="Controlling") # Not normal
qqnorm(myData[myData$Ld72 <= 40,]$MAXFWT,col="#9c560c")
qqline(myData[myData$Ld72 <= 40,]$MAXFWT,col="#a34b70")
shapiro.test(myData[myData$Ld72 <= 40,]$MAXFWT) #0.009785 < 0.05
# We have enough evidence to reject null --> NOT Normal

leveneTest(MAXFWT~as.factor(Ld72),data=myData)
# 0.7382 > 0.05 --> We do not have enough evidence to reject null --> NOT normal & equal variance 

#                ------------------------------------------------------
# Is "MAXWT" different between the different Lead types with the different genders?
# Does the mean of the group MAXWT differs from the mean of the group Lead types and gender?
# Null : there is NO difference between groups
# Alternative : there is a difference between groups
# !! Checking normality , To determine which test to use 

# Assuming normality and homoscedasticity 
v1=aov(MAXFWT~Lead_type*Sex, myData)
summary(v1)
report(v1)
# Pr(>F)value of the sex is 0.33340 > alpha(0.05)
# Not significant so we do not have enough evidence to reject the null
# So, we do not have evidence to say that MAXFWT is different between different gender

# Pr(>F)value of the lead type is  0.00142 < alpha(0.05)
# is significant so  we have enough evidence to reject the null 
# So, we have evidence to say that MAXFWT is different between different lead types

# Pr(>F)value of the sex and lead type is 0.11060 > alpha(0.05)
# Not significant and we do not have enough evidence to reject the null
# So, we do not have evidence to say that MAXFWT is different between different gender and different lead type

tukey <- TukeyHSD(v1)
tukey
plot(tukey ,col="#7109b8")

# The first column shows the difference between the means of the two groups being compared. 
# The second column shows the lower and upper bounds of the confidence interval --> the range --> the true population mean of the two groups is estimated to lie with 95% confidence. 
# The third column shows the p-adjusted value --> takes into account multiple comparisons.

# Male:2-Male:1 (0.0036208) & Male:1-Female:2 (0.0044057) --> the p-adjusted values < 0.05.
# So, the results are significant and there is enough evidence to reject the null hypothesis.

# Therefore, we can conclude that there is a significant difference between Male lead type 2 and Male lead type 1
# As well as between Male lead type 2 and Female lead type 1 --> in terms of MAXFWT.

#Confidence intervals for these two comparisons do not contain the value of 0 --> indicates a low p-adjusted value.


# The remaining comparisons have p-adjusted values > 0.05 
#So, there is No significant difference between the groups in terms of MAXFWT. 
#Additionally, the confidence intervals for these comparisons contain the value of 0 --> the high p-adjusted values.

# TukeyHSD(v1)
#______________________________________________________________________________________

# 7.Linear model
#Graph for the data 
plot(myData$Ld72,myData$MAXFWT,col="blue",main="Regression",ylab = "MAXFWT",xlab = "Ld72")
#Do the regression
myData.regression <- lm(MAXFWT~Ld72 , data=myData)
#Look at the R^2, F-value and p-value
summary(myData.regression)
abline(myData.regression,col="#73075a")
confint(myData.regression,'Ld72',level = 0.95)

#----------#
#bonus 
# Fit the linear regression model
model <- lm(MAXFWT~Ld73 , data=myData)
summary(model)

confint(model, 'Ld73', level=0.95)
#point2
Estimate <- predict (model, newdata = data.frame(Ld73=100))
Estimate

