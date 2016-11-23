#' ---
#' title: "TITLE"
#' author: 
#' date: 
#' output:
#'    html_document:
#'      fig_width: 12
#'      fig_height: 12
#'      keep_md: true
#'      toc: true
#'      toc_depth: 2
#' ---
#'
#' **About this document**
#'  About the document
#' 
#'

#' # Load dataset, and do quick analysis
#' 768 adult female Pima Indians living near Phoenix
#+ warning=FALSE, message=FALSE
library(faraway)
library(dplyr)
library(ggplot2)

# make the data available from the faraway package
data(pima, package="faraway")
pima <- tbl_df(pima)

#' | Variable  | Description                      |
#' |-----------|----------------------------------|
#' | pregnant  | number of times pregnant         |
#' | glucose   | glucose concentration            |
#' | diastolic | Diastolic blood pressure (mmHg)  |
#' | triceps   | Triceps skin fold thickness (mm) |
#' | insulin   | 2-hour serum insulin (muU/ml)    |
#' | bmi       | weight in kg/(height in $m^2$)   |
#' | diabetes  | Diabetes pedigree function       |
#' | age       | In Years                         |
#' | test      | 0 if negative, 1 if positive     |
head(pima)
# dplyr::glimpse(pima)
summary(pima)

#' # Some data cleansing
#' The value of 0 appears to be used as a code-value for NANs
sort(pima$diastolic)[1:50]

#' So let's replace with NA
#' 
#' http://stackoverflow.com/questions/27909000/set-certain-values-to-na-with-dplyr
# pima$diastolic[pima$diastolic == 0]  <- NA
# pima$glucose[pima$glucose == 0] <- NA
# pima$triceps[pima$triceps == 0]  <- NA
# pima$insulin[pima$insulin == 0] <- NA
# pima$bmi[pima$bmi == 0] <- NA
pima <- pima %>% mutate(diastolic = replace(diastolic, diastolic == 0, NA))
pima <- pima %>% mutate(glucose   = replace(glucose, glucose == 0, NA))
pima <- pima %>% mutate(triceps   = replace(triceps, triceps == 0, NA))
pima <- pima %>% mutate(insulin   = replace(insulin, insulin == 0, NA))
pima <- pima %>% mutate(bmi       = replace(bmi, bmi == 0, NA))

#' This should be a factor datatype (not int)
#' (we don't want to compute stuff like *average zip code*)
summary(pima$test) 
pima$test <- factor(pima$test)
summary(pima$test)

# this makes it more descriptive
levels(pima$test) <- c("negative","positive")
summary(pima$test)

#' The summary from the "cleaned" data 
summary(pima)

#' # Now we're ready to plot stuffs
#' ## R's Base-graph system
par(mfrow=c(2,3))
hist(pima$diastolic,xlab="Diastolic",main="")
plot(density(pima$diastolic,na.rm=TRUE),main="")
plot(sort(pima$diastolic),ylab="Sorted Diastolic")
plot(diabetes ~ diastolic,pima) # y-x plot using R-formula
plot(diabetes ~ test,pima)      # boxplot since x-argument is a factor

#' ## ggplot
source('~/tak.R')
p1 <- ggplot(pima,aes(x=diastolic)) + geom_histogram()
p2 <- ggplot(pima,aes(x=diastolic)) + geom_density()
p3 <- ggplot(pima,aes(x=diastolic,y=diabetes)) + geom_point()
#http://www.cookbook-r.com/Graphs/Multiple_graphs_on_one_page_(ggplot2)/
multiplot(p1,p2,p3,cols=2)

# test ----
# for faceting: "color", "shape", "fill"
p4a <- ggplot(pima,aes(x=diastolic,y=diabetes,shape=test)) + 
       geom_point() + theme(legend.position = "top", legend.direction = "horizontal")
p4b <- ggplot(pima,aes(x=diastolic,y=diabetes,color=test)) + 
       geom_point() + theme(legend.position = "top", legend.direction = "horizontal")
p4c <- ggplot(pima,aes(x=diastolic,y=diabetes,color=test,shape=test)) + 
  geom_point() + theme(legend.position = "top", legend.direction = "horizontal")
multiplot(p4a,p4b,p4c,cols=2)


p5a <- ggplot(pima,aes(x=diastolic,y=diabetes)) + 
  geom_point(size=1) + facet_grid(~ test)
p5b <- ggplot(pima,aes(x=diastolic,y=diabetes)) + 
  geom_point(size=1,color='orange') + facet_grid(~ test)
p5c <- ggplot(pima,aes(x=diastolic,y=diabetes,color=test)) + 
  geom_point(size=1) + facet_grid(~ test)
multiplot(p5a,p5b,p5c)

#' # Example: manilius data
#' $$\text{arc} = \beta + \alpha \text{sin-ang} + \gamma \text{cosang}$$
data(manilius, package="faraway")
manilius <- tbl_df(manilius)
head(manilius)

#' Approach1: divide group into 3 groups, and solve system of linear equations
(moon3 <- aggregate(manilius[,1:3],list(manilius$group), sum))
solve(cbind(9,moon3$sinang,moon3$cosang), moon3$arc) # alpha,beta,gamma


#' Approach2: linear least squares (1805 Adrien Legendre)
#' $$arc_i = \beta + \alpha \text{sin-ang}_i + \gamma \text{cos-ang}_i +\varepsilon_i$$
lmod <- lm(arc ~ sinang + cosang, manilius)
coef(lmod)

#' # Example: child-height prediction
#' $$childHeight = \alpha + \beta midparentHeight + \varepsilon$$
data(GaltonFamilies, package="HistData")
GaltonFamilies <- tbl_df(GaltonFamilies)
head(GaltonFamilies)

par(mfrow=c(2,2))
plot(childHeight ~ midparentHeight, GaltonFamilies)

lmod <- lm(childHeight ~ midparentHeight, GaltonFamilies)
coef(lmod)
plot(childHeight ~ midparentHeight, GaltonFamilies)
abline(lmod)

(beta <- with(GaltonFamilies, cor(midparentHeight, childHeight) * sd(childHeight) / sd(midparentHeight)))
(alpha <- with(GaltonFamilies, mean(childHeight) - beta * mean(midparentHeight)))
(beta1 <- with(GaltonFamilies, sd(childHeight) / sd(midparentHeight)))
(alpha1 <- with(GaltonFamilies, mean(childHeight) - beta1 * mean(midparentHeight)))
plot(childHeight ~ midparentHeight, GaltonFamilies)
abline(lmod)
abline(alpha1, beta1, lty=2) # dashed line
