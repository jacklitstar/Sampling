# Sampling Design Notebook

**Jack H**   
Jun 6 2025

---
This notebook contains code for my sampling design course, lectured by Prof. Ding

---


To run this jupyter notebook, install the R kernel in your developing enviornment.
- **VScode** : Select kernel - Jupyter kernel - R
- **Google Colab**: Runtime - Change runtime type
- **Jupyter Notebook Web**: Kernel - Change kernel
- **R Studio**: Use `Notebook.rmd` instead

---


The Examples are from:《抽样调查理论与方法（第二版）》冯士雍、倪加勋、邹国华


# Chapter 2
## Functions
### Confidence Interval, d, r
$$\left[ \bar y \pm z_{\alpha /2 } \sqrt{\widehat {\mathrm{Var}} (\bar y )}\right]$$
 $$d = \sqrt{\widehat {\mathrm{Var}} (\bar y )}$$
 $$r = \frac{d}{\bar y}$$

```r
conf.interval=function(para.est, SD.est, alpha)
##############    Input     ########################
## para.est = estimator of character
## SD.est   = estimator of sd
## alpha    = confidence level (1-alpha)
##############    Output    ########################
## left     = left of confidence interval
## right    = right of confidence interval
####################################################
{
  quan=qnorm(1-alpha/2)
  
  para.left =para.est-quan*SD.est
  para.right=para.est+quan*SD.est
  
  return(list(left=para.left, right=para.right))
}


dr.error=function(para.est, SD.est, alpha)
##############    Input     #######################
## para.est = estimator of character
## SD.est   = estimator of sd
## alpha    = confidence level (1-alpha)
##############    Output    ########################
## d        = absolute error
## r        = relative error
####################################################
{
  quan=qnorm(1-alpha/2)
  
  d=quan*SD.est
  r=quan*SD.est/para.est

  return(list(d=d, r=r))
}
```

### Sample Mean
$$\bar y = \frac{1}{n} \sum_{i=1}^{n} y_i$$

```r
sample.mean=function(mydata, alpha)
##############    Input     ########################
## mydata = srs sample vector
## alpha = confidence level 1-alpha
##############    Output    ########################
## mean.est = estimator of sample mean
## sd.est   = estimator of sample sd
## left     = left of confidence interval
## right    = right of confidence interval
## d        = absolute error
## r        = relative error
####################################################
{
  size=length(mydata)
  
  mean.est=mean(mydata)
  sd.est  =sqrt(var(mydata)/size)
  
  ci.result=conf.interval(mean.est, sd.est, alpha)
  left =ci.result$left
  right=ci.result$right
  
  dr.result=dr.error(mean.est, sd.est, alpha)
  d=dr.result$d
  r=dr.result$r
  
  return(list(mean.est=mean.est, sd.est=sd.est, 
              left=left, right=right, d=d, r=r))
}
```


## Problems
### 2.3
```r
####   source functions   #################
source("Code/ci.r")
source("Code/sample mean.r")
####  read/generate data   ################
ex1=read.csv("Data/ex1.csv")
myindex=c(1)
mydata=ex1[,myindex]
alpha=0.01
####  data analysis   #####################
result=sample.mean(mydata, alpha)
print(result)
```

# Chapter 3
Basic R
```r
# Automatically set the working directory to the directory of the currently open file
# vscode fix

if (requireNamespace("rstudioapi", quietly = TRUE)) {
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}

# Your code here
print(getwd())
```

```r
## Ch1  R basic ## 
# R Basic 

x=c(10.4, 5.6, 3.1, 6.4, 21.7) #makes a vector
print(x)

y=c(x,0,x) 

x=1:5
y=100:150
z=c(x,y) #concat a and y
z
v=assign("x", c(5.6, 3.1, 6.4, 21.7))
v

## vector ##
x=c(-1, 0, 2)
y=c(3, 8, 2)

x+y
x-y
x*y
x/y
x^2
y^x

v=2*x+y+1
v

x=c(1,2,3)
y=c(2,4,6,8,10)

exp(x)
sqrt(y)
log(y)

z=c(-1,2,4)
b=exp(z)
a=sqrt(z)

x=c(10, 6, 4, 7, 8)
min(x)
max(x)
range(x)

which.max(x)
which.min(x)
#gives the index

sum(x)
prod(x)
length(x)

x=3.789
ceiling(x)
floor(x)
trunc(x)
round(x, 2)

## remarks ############################
a=1+2+3+4+5+6+7+8+9+10
print(a)
#######################################

x=rnorm(1000, mean=-2, sd=0.5)
print(x)

set.seed(315)
x=rnorm(1000);print(x)

median(x)
mean(x) 
var(x)
sd(x)
cv=sd(x)/mean(x)

## d, p, q, r #########################
dnorm(3, 2, sqrt(4))    ## density
pnorm(4, 2, sqrt(4))    ## distribution

alpha=0.05
qnorm(1-alpha/2, 0, 1)  ## quantile, R quantile start from lower quantile

rnorm(1000, 0, 1)       ## random sampling

## :  ###############################
x=2.312:6
y=4:7.6  
z=1:100

## sequence ##########################
v=seq(from=-5, to=5, by=0.2)
v

jpeg("fig1.jpeg", height= 800, width=800)
x=seq(from=-10, to=10, by=0.02)
y=x^2
plot(x,y)
dev.off()

w=seq(from=0, to= 10, by = 1) #same as python: range()
z=seq(from=0, to= 10, length.out = 10)


## repeat #######################
w=rep(3, 100) #rep(3.times = 100)
w
x=c(1,2,3)
u=rep(x, 10) 
u # = 1 2 3 1 2 3 1 2 3....#

1>2
3<=3
1==3
1!=3

T&F
T|F
!T

all(1:7>3) 
any(1:7>3) 


x=c(1:3, NA)
is.na(x)

x=c("Height", "Weight")
y=paste("My", "name", "is") 

print(x)
print(y)
cat(x,"\n", y, "\n") 
cat("My name is:", "\n")

size=800
alpha=0.05
d=10
r=0.1

sink("result1.txt")  # output to file
cat("my result is:","\n")
cat("the sample size =", size, "\n")
cat("the significant level =", 1-alpha, "\n")
cat("the absolute error =", d, "\n")
cat("the relative error =", r, "\n")
sink() # stops output to file


x=c(1,4,7)
x[2] # the index of R starts at 1
x[1:2]

y=1:100
print(y)

index=96:100
y[index] 
y[-index] #negative index means exclude the index

## matrix ######################
A=matrix(1:15, nrow=3, ncol=5) #by default fills by column
A=matrix(1:15, ncol=5, nrow=3)

A=matrix(1:15, 3, 5)
A=matrix(1:15, 5, 3)

A

B=matrix(1:15, nrow=3, ncol=5, byrow=T) #fill by row
B

A+B
A-B
A*B
A/B
# per element operation

t(A)

A=matrix(1:100, nrow=10, ncol=10)
A[10,10]=200
A
det(A)


x=1:5
y=2*1:5 # same as 2*(1:5)
y
x%*%y #inner product
crossprod(x,y)
tcrossprod(x,y) 

x%o%y #outer product
outer(x, y) 

A=matrix(1:9, nrow=3)
A
B=matrix(9:1, nrow=3)
B 
A%*%B  
A*B

v=rep(1, 5)
v

#the diag function can take 3 kind of inputs, a number, a vector or a matrix.
I5=diag(v)
I5 

p=10
I=diag(rep(1, p))
I 

A=matrix(1:9, nrow=3)
A
a=diag(A)
a 

A=matrix(1:9, nrow=3)
A
B=diag(diag(A))
B

A=matrix(5.6, nrow=1, ncol=1)
A
B=diag(diag(A)) ### diag(diag()) 
B

A=matrix(1:9, nrow=3, byrow=T)
A[3,3]=10
A
b=rep(1,3)
b
x=solve(A,b)
x
D=solve(A)
D

### remarks #####################################
B=diag(c(100000000000, 0.00001))
B
det(B)
solve(B)
rcond(B)>.Machine$double.eps

if(rcond(B)>.Machine$double.eps)
{B.inv=solve(B)}
if(rcond(B)<=.Machine$double.eps)
{cat("the matrix is computationally sigular!")}
##################################################

### eigen value ###################
A=matrix(1:9, nrow=3, byrow=T)
A[3,3]=10
A
Sm=eigen(A)
Sm 
Sm$values
Sm$vectors

## list ### 
mylist=list(name="Smith", age=18, a=1:3, matrix=A)
mylist
mylist$age
mylist$matrix


A=matrix(1:4,2,2)
B=matrix(rep(1,4),2,2)
kronecker(A,B) 

dim(A)
nrow(A)
ncol(A) 

A
B
cbind(A, B)
rbind(A, B) 

A=matrix(1:16,nrow=2,ncol=8)
A
as.vector(A)
as.vector(t(A))

D=matrix(1:100, ncol=2)
D
D[2,1]
D[50,]  ## is a vector 
# vectors in R are stored as columns, even if it is extracted from a matrix's row. therefore transpose is needed when dealing with row vectors.
D[,2]

H=matrix(rep(1,20),nrow=10)
H
t(t(H)+D[50,])

index=c(2,5,10,45,32,20,20,20)
D[index,]


X=matrix(1:6, ncol=2)
X
colnames(X)=c("First", "Second")
rownames(X)=c("one", "two", "three") 
X  # matrix

X=as.data.frame(X)
X  # data frame
X$First

A=matrix(1:12, nrow=3, ncol=4)
A
rowSums(A)
rowMeans(A)
colSums(A)
colMeans(A)

#apply(matrix, 1/2,function)  1 for per row, 2 for per column
apply(A, 1, sum)
apply(A, 2, mean)
apply(A, 1, var)
apply(A, 2, sd)
apply(A, 1, prod)


df=data.frame(
  Name=c("Alice", "Becka", "James", "Jeffrey", "John"), 
  Sex=c("F", "F", "M", "M", "M"), 
  Age=c(13, 13, 12, 13, 12),
  Height=c(56.5, 65.3, 57.3, 62.5, 59.0),
  Weight=c(84.0, 98.0, 83.0, 84.0, 99.5)
)
print(df)

df$Weight
df$Age


data1=read.table("EDUC_SCORES.txt", header=T)
print(data1) 
data2=read.csv("Data/educ_scores.csv")
print(data2)

write.table(data1, file="data1.txt")
write.csv(data2, file="data2.csv") 


############ if else ############
np=2
if(np==1) {a=1} else {a=2}

a=ifelse(np==1, 1, 2)

myfun=function(np)
{
  if(np==1) 
    {a=1} 
  else 
    {a=2}
return(a)
}
myfun(2)



mysolve=function(mymatrix)
{
  if(rcond(mymatrix)>.Machine$double.eps)
  {myinv=solve(mymatrix)}
  else
  {cat("the matrix is computationally sigular!")}
}

B=diag(c(100000000000, 0.00001))
mysolve(B)

A=matrix(1:9, nrow=3, byrow=T)
A[3,3]=10
A
print(mysolve(A))



B=matrix(1:12, nrow=3, ncol=4)
B
A=matrix(0, nrow=3, ncol=4)
A
for (i in 1:3)
{
  for (j in 1:4)
  {
    A[i,j]=1/B[i,j]
  }
} 
print(A)

1/B

B=matrix(1:1000*1000, nrow=1000, ncol=1000)
B
A=matrix(0, nrow=1000, ncol=1000)
for (i in 1:1000)
{
  for (j in 1:1000)
  {
    A[i,j]=1/B[i,j]
  }
} 
print(A)


twosam=function(y1, y2) 
{
  n1=length(y1)
  n2=length(y2)
  
  yb1=mean(y1)
  yb2=mean(y2)
  
  s1=var(y1)
  s2=var(y2)
  
  s=((n1-1)*s1+(n2-1)*s2)/(n1+n2-2)
  tst=(yb1 - yb2)/sqrt(s*(1/n1+1/n2))
  return(tst)
}

source("Code/two mean test.r")
A=c(79.98, 80.04, 80.02, 80.04, 80.03, 80.03, 80.04, 
    79.97, 80.05, 80.03, 80.02, 80.00, 80.02)
B=c(80.02, 79.94, 79.98, 79.97, 79.97, 80.03, 79.95,
    79.97)

two.mean.test(A,B)  
```

# Chapter 4 SRS
## Functions
### Sampling
```r
## SRS sampling ###############################
N=100   ## size of population
n=10    ## size of sample 
set.seed(555)
## simple random sampling without replacement
mysrs=sample(1:N, n)  
print(mysrs)
## simple random sampling with replacement
mysrs=sample(1:N, n, replace = TRUE)
print(mysrs)
## srs data ###################################
full.data=read.csv("Data/2015city.csv")
N=nrow(full.data)
n=5
subset=sample(1:N, n)
srs.data=full.data[subset,]
print(srs.data)
```

### Estimation of Population Mean $\bar Y$

1. **Point Estimation**
 $$\bar y = \frac 1 n \sum_{i=1}^n y_i$$ 
2. **Unbiased estimator of $\bar Y$**
$$\mathrm E (\bar y ) = \bar Y \quad (UE)$$
3. **Variance of estimation:**
 $$Var(\bar y ) = \frac{1-f}{n}S^2$$
 where $f = \frac{n}{N}$ and $S^2$ is the variance of population $Y$ (unknown)
4. **Estimation of variance:**
 $$\hat{\mathrm{Var} } (\bar y ) = \frac{1-f}{n} s^2 $$
 where 
 $$s^2 = \frac{1}{n-1}\sum_{i=1}^n (y_i - \bar y )^2 $$
5. **Confidence Interval**
 $$\left[ \bar y \pm z_{\alpha /2 } \sqrt{\widehat {\mathrm{Var}} (\bar y )}\right]$$
 $$d = \sqrt{\widehat {\mathrm{Var}} (\bar y )}$$
 $$r = \frac{d}{\bar y}$$


```r
srs.mean=function(N=NULL, mysample, alpha)
{
  n=length(mysample)
  f=ifelse(is.null(N), 0, n/N)
  
  ybar=mean(mysample)
  ys2 =var(mysample)
  
  ybar.var=((1-f)/n)*ys2
  ybar.sd =sqrt(ybar.var)
  
  ci.result=conf.interval(ybar, ybar.sd, alpha)
  d    =ci.result$d
  r    =ci.result$r
  left =ci.result$left
  right=ci.result$right
  
  return(list(ybar=ybar, ybar.var=ybar.var, ybar.sd=ybar.sd, 
              d=d, r=r, left=left, right=right))
}
```

### Estimation of Population Total $Y_T = N \bar Y = \sum_{i=1}^N Y_i$
1. **Point Estimation**
 $$\hat y_T = N \bar y $$
2. **Unbiased Estimator**
 $$\mathrm E (\hat y_T) = N\cdot  \mathrm E (\bar y) = N \bar Y = Y_T$$
3. **Variance of Estimation**$$Var(\hat y_T) = N^2 Var (\bar y ) = N^2 \frac{1-f}n S^2$$
4. **Estimation of Variance** $$\hat Var(\hat Y_T) = N^2 \frac{1-f}n s^2$$
5. **Confidence Interval**
 $$\left[\hat y_T \pm z_{\alpha /2 }  \sqrt{\widehat {\mathrm{Var}} (\hat y_T)}\right]$$
 $$d = z_{\alpha /2 }\sqrt{\widehat {\mathrm{Var}} (\hat y_T)}$$
 $$r = \frac{d}{\hat y_T}$$



 ```r
 srs.total=function(N=NULL, mysample, alpha)
{
  n=length(mysample)
  f=ifelse(is.null(N), 0, n/N)
  
  ybar=mean(mysample)
  ys2 =var(mysample)
  
  ytot.est=N*ybar
  ytot.var=N^2*((1-f)/n)*ys2
  ytot.sd =sqrt(ytot.var)
  
  ci.result=conf.interval(ytot.est, ytot.sd, alpha)
  d    =ci.result$d
  r    =ci.result$r
  left =ci.result$left
  right=ci.result$right
  
  return(list(ytot.est=ytot.est, ytot.var=ytot.var, ytot.sd=ytot.sd, 
              d=d, r=r, left=left, right=right))
}
```


### Estimation of Population Proportion $P$
Define:
- Population Proportion $P = \frac{1}N \sum_{i=1}^N Y_i = \bar Y $
- Population Total $A = \sum Y_i = NP$
- Population Variance $$S^2 = \frac{N}{N-1} P(1-P) =\frac{N}{N-1} PQ \quad \text{where } Q = 1-P$$
  
Let the observed $y_1 ,\ldots, y_n$ have property with count $a$
1. $\hat p = \bar y = \frac a n$
2. UE
3. Variance of Estimation $$Var(\hat p) = \frac{1-f}n (\frac{N}{N-1}PQ)$$
4. Estimation of Variance $$\hat Var(\hat p ) = \frac{1-f}{n-1}\hat p \hat q$$



```r
srs.prop=function(N=NULL, n, event.num, alpha)
{
  f=ifelse(is.null(N), 0, n/N)
  
  p.est=event.num/n
  p.var=((1-f)/(n-1))*p.est*(1-p.est)
  p.sd =sqrt(p.var)

  ci.result=conf.interval(p.est, p.sd, alpha)
  d    =ci.result$d
  r    =ci.result$r
  left =ci.result$left
  right=ci.result$right
  
  return(list(p.est=p.est, p.var=p.var, p.sd=p.sd, 
              d=d, r=r, left=left, right=right))
}
```

### Estimation of Population total $A$
1. $\hat A = N\bar y = N \hat p$
2. UE
3. $$Var(\hat A) = N^2 \frac{1-f}{n} \frac {N}{N-1} PQ$$
4. $$\hat Var(\hat A) = N^2 \frac{1-f}{n} \frac {n}{n-1} \hat p \hat q$$

```r
srs.num=function(N=NULL, n, event.num, alpha)
{
  f=ifelse(is.null(N), 0, n/N)
  
  p.est=event.num/n
  p.var=((1-f)/(n-1))*p.est*(1-p.est)
    
  A.est=N*p.est
  A.var=N^2*p.var
  A.sd =sqrt(A.var)
  
  ci.result=conf.interval(A.est, A.sd, alpha)
  d    =ci.result$d
  r    =ci.result$r
  left =ci.result$left
  right=ci.result$right
  
  return(list(A.est=round(A.est), A.var=A.var, A.sd=A.sd, 
              d=d, r=r, left=round(left), right=round(right)))
}
```

### Sample Size $n_{\min}$ for Estimating Population Mean $\bar Y$

**Step 1** Calculate $n_0$
Here $S^2$ and $\bar Y$ are given from historical data.
$$n_0 = \frac{S^2}{V} = \begin{cases} \frac{S^2}V & V=V\\
\frac{S^2}{C^2\bar Y ^2 } & C = \sqrt V/\bar Y \\
\frac{z_{\alpha/2}^2 S^2}{d^2} & d = z_{\alpha /2}\sqrt V\\
\frac{z_{\alpha / 2 } ^2 S^2}{r^2 \bar Y ^2 } & r = z_{\alpha /2} \sqrt V / \bar Y 
\end{cases}$$


**Step 2**
$$n_{\min} = \begin{cases}\frac{n_0}{1+ \frac{N_0}{N} } & \text{given reasonable } N \\ n_0 & \text{when $N$ is very big}\end{cases}$$

```r
size.mean=function(N=NULL, Mean.his=NULL, Var.his, method, bound, alpha)
{
  quan=qnorm(1-alpha/2)
  
  if (method=="V") {n0=Var.his/bound}
  if (method=="CV"){n0=Var.his/(bound*Mean.his)^2}
  if (method=="d") {n0=(quan/bound)^2*Var.his}
  if (method=="r") {n0=(quan/(bound*Mean.his))^2*Var.his}
  
  size=ifelse(is.null(N), n0, n0/(1+n0/N))
  return(list(method=method, n0=round(n0), size=round(size)))
}
```

### Sample Size for Estimating Proportion $P$

Here $P$ and $Q = 1 - P$ are given from historical data.
$$n_0 = \frac{PQ}{V} = \begin{cases} \frac{PQ}V \\ \frac{Q}{C^2P} \\\frac{z_{\alpha /2}^2 PQ }{d^2}\\ \frac{z_{\alpha /2}^2 Q }{r^2 P } \end{cases}$$

$$n_{\min} = \begin{cases} \frac{n_0}{1 + \frac{n_0- 1}{N} } & \text{Given } N\\ n_0 & N >> n_0 \end{cases}$$

```r
size.prop=function(N=NULL, Prop.his, method, bound, alpha)
{
  quan=qnorm(1-alpha/2)
  
  if (method=="V") {n0=Prop.his*(1-Prop.his)/bound}
  if (method=="CV"){n0=(1-Prop.his)/(bound^2*Prop.his)}
  if (method=="d") {n0=(quan^2)*Prop.his*(1-Prop.his)/(bound^2)}
  if (method=="r") {n0=(quan^2)*(1-Prop.his)/(bound^2*Prop.his)}
  
  size=ifelse(is.null(N), n0, n0/(1+(n0-1)/N))
  return(list(method=method, n0=ceiling(n0), size=round(size)))
}
```
## Examples
### 3.5
```r
### Example 1: example 3.5 #########################
source("Code/ci.r")
source("Code/srs.r")
########## Input data  #############################
N=5443
alpha=0.05

ex1=read.csv("Data/ex1.csv")
print(ex1)
X=ex1$X
Y=ex1$Y
######### data analysis  ###########################
### mean ####
ex1.result1=srs.mean(N, X, alpha)
print(ex1.result1)

ex1.result2=srs.mean(N, Y, alpha)
print(ex1.result2)

### total ####
ex1.result3=srs.total(N, X, alpha)
print(ex1.result3)

ex1.result4=srs.total(N, Y, alpha)
print(ex1.result4)
```
### 3.11
```r
## Example 2: exercise 3.11 ########################################################################
source("Code/ci.r")
source("Code/srs.r")
########## Input data  #############################
N=NULL
#N = 1000
n=250
num=50
#num = sum(mysample)
alpha=0.05
######### data analysis  ###########################
p.result=srs.prop(N, n, num, alpha)
print(p.result)

A.result=srs.num(N, n, num, alpha)
print(A.result)
```

### 3.7
```r
## Example 3: example 3.7 ##########################################################################
source("Code/ci.r")
source("Code/srs.r")
source("Code/srs size.r")

########## Input data  #############################
ex3=read.csv("Data/ex1.csv")
print(ex3)
X=ex3$X
Y=ex3$Y

N=5443
Var.his=4^2
CV.his=0.9

d.bound=0.2
r.bound=0.05

alpha=0.05
######### data analysis  ###########################
re1=size.mean(N, Mean.his=NULL, Var.his, method="d", bound=d.bound, alpha)
print(re1)

re2=size.mean(N, Mean.his=4/0.9, Var.his, method="r", bound=r.bound, alpha)
print(re2)
```

### 3.8
```r
source("Code/ci.r")
source("Code/srs.r")
source("Code/srs size.r")

########## Input data  #############################
N=NULL
Prop.his=18/1000

d.bound=0.5/1000
r.bound=5/100

alpha=0.05

######### data analysis  ###########################
re1=size.prop(N, Prop.his, method="d", bound=d.bound, alpha)
print(re1)

re2=size.prop(N, Prop.his, method="r", bound=r.bound, alpha)
print(re2)
```
# Chapter 5 Stratified Sampling
## Functions
### Esimation of Population Mean $\bar Y$

1. $$\bar y_{st} = \sum_{h = 1}^ L W_h \bar y_h $$
2. $$E(\bar y_{st}) = \bar Y $$
3. $$Var(\bar y_{st}) = \sum_{h=1}^L W_h^2 \frac{1- f_h }{n_h} S_h^2$$
4. $$\hat Var (\bar y_{st})  =\sum_{h=1}^L W_h^2 \frac{1- f_h }{n_h} s_h^2$$

```r
stra.srs.mean1=function(Nh, nh, yh, s2h, alpha)
{
  stra.num=length(Nh)
  Wh=Nh/sum(Nh)
  fh=nh/Nh
  
  yh.est  =rep(0, stra.num)
  yh.var  =rep(0, stra.num)
  yh.sd   =rep(0, stra.num)
  yh.left =rep(0, stra.num)
  yh.right=rep(0, stra.num)
  
  for (h in 1:stra.num)
  {
    yh.est[h]=yh[h]
    yh.var[h]=((1-fh[h])/nh[h])*s2h[h]
    yh.sd[h]=sqrt(yh.var[h])
      
    ci.stra=conf.interval(yh.est[h], yh.sd[h], alpha)
    yh.left[h] =ci.stra$left
    yh.right[h]=ci.stra$right
  }
  
  stra.result=cbind(Nh, nh, Wh, yh.est, yh.var, yh.sd, yh.left, yh.right)
  
  mean.est=sum(Wh*yh.est)
  mean.var=sum(Wh^2*yh.var)
  mean.sd =sqrt(mean.var)
  
  ci.result=conf.interval(mean.est, mean.sd, alpha)
  mean.left =ci.result$left
  mean.right=ci.result$right
  
  mean.result=matrix(c(mean.est, mean.var, mean.sd, mean.left, mean.right), nrow=1)
  colnames(mean.result)=c("mean.est", "mean.var", "mean.sd", "mean.left", "mean.right")
  rownames(mean.result)="Strat"
  return(list(stra.result=as.data.frame(stra.result), mean.result=as.data.frame(mean.result)))
}

```

```r

stra.srs.mean2=function(Nh, mysample, stra.index, alpha)
{
  stra.num=length(Nh)
  Wh=Nh/sum(Nh)
  
  yh.est  =rep(0, stra.num)
  yh.var  =rep(0, stra.num)
  yh.sd   =rep(0, stra.num)
  yh.left =rep(0, stra.num)
  yh.right=rep(0, stra.num)
  
  for (h in 1:stra.num)
  {
    sample.hth=mysample[stra.index==h]
    stra.result=srs.mean(Nh[h], sample.hth, alpha)
    
    yh.est[h]  =stra.result$ybar
    yh.var[h]  =stra.result$ybar.var
    yh.sd[h]   =stra.result$ybar.sd
    yh.left[h] =stra.result$left
    yh.right[h]=stra.result$right
  }
  
  stra.result=cbind(Nh, Wh, yh.est, yh.var, yh.sd, yh.left, yh.right)
  
  mean.est=sum(Wh*yh.est)
  mean.var=sum(Wh^2*yh.var)
  mean.sd =sqrt(mean.var)
  
  ci.result=conf.interval(mean.est, mean.sd, alpha)
  mean.left =ci.result$left
  mean.right=ci.result$right
  
  mean.result=matrix(c(mean.est, mean.var, mean.sd, mean.left, mean.right), nrow=1)
  colnames(mean.result)=c("mean.est", "mean.var", "mean.sd", "mean.left", "mean.right")
  rownames(mean.result)="Strat"
  return(list(stra.result=as.data.frame(stra.result), mean.result=as.data.frame(mean.result)))
}
```

### Stratified Sampling Estimation of Population Proportion $P$

1. **Estimator for Population Proportion**:
 $$
   \hat{p}_{st} = \sum_{h=1}^L W_h \hat{p}_h = \sum_{h=1}^L W_h \cdot \frac{a_h}{n_h}
   $$

2. **Expected Value**:
 $$
   E(\hat{p}_{st}) = P
   $$

3. **Variance**:
 $$
   Var(\hat{p}_{st}) = \sum_{h=1}^L W_h^2 Var(\hat{p}_h) = \sum_{h=1}^L W_h^2 \left( \frac{1 - f_h}{n_h } \cdot \frac{N_h}{N_h - 1} P_h Q_h \right)
   $$

4. **Estimated Variance**:
 $$
   \widehat{Var}(\hat{p}_{st}) = \sum_{h=1}^L W_h^2 \widehat{Var}(\hat{p}_h) = \sum_{h=1}^L W_h^2 \left( \frac{1 - f_h}{n_h } \cdot \frac{n_h}{n_h - 1} \hat{p}_h \hat{q}_h \right)
   $$

5. **Confidence Interval (CI)**:
 $$
   CI \quad d.r.
   $$

```r
stra.srs.prop1=function(Nh, nh, ah, alpha)
{
  stra.num=length(Nh)
  Wh=Nh/sum(Nh)
  fh=nh/Nh
  
  ph.est  =rep(0, stra.num)
  ph.var  =rep(0, stra.num)
  ph.sd   =rep(0, stra.num)
  ph.left =rep(0, stra.num)
  ph.right=rep(0, stra.num)
  
  for (h in 1:stra.num)
  {
    ph.est[h]=ah[h]/nh[h]
    ph.var[h]=((1-fh[h])/(nh[h]-1))*ph.est[h]*(1-ph.est[h])
    ph.sd[h] =sqrt(ph.var[h])
    
    ci.stra=conf.interval(ph.est[h], ph.sd[h], alpha)
    ph.left[h] =ci.stra$left
    ph.right[h]=ci.stra$right
  }
  
  stra.result=cbind(Nh, nh, ah, Wh, ph.est, ph.var, ph.sd, ph.left, ph.right)
  
  prop.est=sum(Wh*ph.est)
  prop.var=sum(Wh^2*ph.var)
  prop.sd =sqrt(prop.var)
  
  ci.result=conf.interval(prop.est, prop.sd, alpha)
  prop.left =ci.result$left
  prop.right=ci.result$right
  
  prop.result=matrix(c(prop.est, prop.var, prop.sd, prop.left, prop.right), nrow=1)
  colnames(prop.result)=c("prop.est", "prop.var", "prop.sd", "prop.left", "prop.right")
  rownames(prop.result)="Prop"
  return(list(stra.result=as.data.frame(stra.result), prop.result=as.data.frame(prop.result)))
}


stra.srs.prop2=function(Nh, nh, ah, alpha)
{
  stra.num=length(Nh)
  Wh=Nh/sum(Nh)
  
  ph.est  =rep(0, stra.num)
  ph.var  =rep(0, stra.num)
  ph.sd   =rep(0, stra.num)
  ph.left =rep(0, stra.num)
  ph.right=rep(0, stra.num)
  
  for (h in 1:stra.num)
  {
    stra.result=srs.prop(Nh[h], nh[h], ah[h], alpha)
    ph.est[h]  =stra.result$p.est
    ph.var[h]  =stra.result$p.var
    ph.sd[h]   =stra.result$p.sd
    ph.left[h] =stra.result$left
    ph.right[h]=stra.result$right
  }
  stra.result=cbind(Nh, nh, ah, Wh, ph.est, ph.var, ph.sd, ph.left, ph.right)
  
  prop.est=sum(Wh*ph.est)
  prop.var=sum(Wh^2*ph.var)
  prop.sd =sqrt(prop.var)
  
  ci.result=conf.interval(prop.est, prop.sd, alpha)
  prop.left =ci.result$left
  prop.right=ci.result$right
  
  prop.result=matrix(c(prop.est, prop.var, prop.sd, prop.left, prop.right), nrow=1)
  colnames(prop.result)=c("prop.est", "prop.var", "prop.sd", "prop.left", "prop.right")
  rownames(prop.result)="Prop"
  return(list(stra.result=as.data.frame(stra.result), prop.result=as.data.frame(prop.result)))
}
```

### When given $n$, determine $w_h$ and $n_h$ for each stratum

1. **Proportional Allocation (Prop)**:
    $$
    W_h = \frac{N_h}{N}
    $$
2. **Optimal Allocation (Opt)**:
    $$
    W_h = \frac{\frac{N_h S_h}{\sqrt{c_h}}}{\sum_{h=1}^L \frac{N_h S_h}{\sqrt{c_h}}}
    $$
3. **Neyman Allocation (Neyman)**:
    $$
    W_h = \frac{\frac{N_h S_h}{\sqrt{c}}}{\sum_{h=1}^L \frac{N_h S_h}{\sqrt{c}}} = \frac{N_h S_h}{\sum_{h=1}^L N_h S_h}
    $$

```r
strata.weight=function(Wh, S2h, Ch=NULL, allocation)
{
  if (allocation=="Prop") 
  {
    wh=Wh
  }
  if (allocation=="Opt") 
  {
    wh=(Wh*sqrt(S2h)/sqrt(Ch))/sum(Wh*sqrt(S2h)/sqrt(Ch))
  }
  if (allocation=="Neyman") 
  {
    wh=(Wh*sqrt(S2h))/sum(Wh*sqrt(S2h))
  }
  return(wh)
}

strata.size=function(n, Wh, S2h, Ch=NULL, allocation)
{
  wh=strata.weight(Wh, S2h, Ch, allocation)
  nh=wh*n 
  return(list(n=n, allocation=allocation, wh=wh, nh=ceiling(nh)))
}
```

### When given $V,C,d,r$ of $\bar Y$ , determine $n$ and $n_{h}$ 
**Step 1** Calculate $w_h$ with different allocation methods.
$$n_h = w_h n $$
$$w_h = \begin{cases}W_h & \text{prop} \\ \frac{Wh S_h /\sqrt {C_h} }{\sum_h W_h Sh/\sqrt {C_h} } & \text{opt} \\ \frac{W_hS_h}{\sum W_h S_h } & \text{Neyman}\end{cases}$$

**Step 2**
Calculate $n_{\min}$ :
$$n_{\min} = \frac{\sum_h W_h^2 S_h^2/w_h }{V + \frac 1 N \sum_h W_h S_h^2}$$
where
$$V = \begin{cases} V & V\\ C^2\bar Y ^2 & C \\ (d/z_{\alpha/2})^2 & d \\ (r\bar Y / z_{\alpha/2})^2 & r\end{cases}$$

$S_h^2, \bar Y$ are given from historical data.

**Step 3** $$n_{h{\min}} = w_h n_{\min}$$

```r
strata.mean.size=function(Nh, S2h, Ch=NULL, allocation, method, bound, Ybar=NULL, alpha=NULL)
{
  N=sum(Nh)
  Wh=Nh/N
  
  wh=strata.weight(Wh, S2h, Ch, allocation)
  var.bound=VCdr.transfer(method, bound, Ybar, alpha)
  
  n=sum(Wh^2*S2h/wh)/(var.bound+sum(Wh*S2h)/N)
  nh=wh*n
return(list(method=method, bound=bound, allocation=allocation, n=ceiling(n), nh=ceiling(nh)))  
}
```

### Given $V,C,d,r$ of $P$, determine $n$ and $n_h$
$$S_h^2 = \frac{N_h}{N_h - 1} P_h Q_h$$
```r
strata.prop.size=function(Nh, Ph, Ch=NULL, allocation, method, bound, Ybar=NULL, alpha=NULL)
{
  S2h=(Nh/(Nh-1))*Ph*(1-Ph)
  size.result=strata.mean.size(Nh, S2h, Ch, allocation, method, bound, Ybar, alpha)
  return(size.result)  
}
```

### Calculate $V$ based on $C,d,r$
```r
VCdr.transfer=function(method, bound, Ybar=NULL, alpha=NULL)
{
  if (method=="V") 
  {
    var.bound=bound
  }
  
  if (method=="C")
  {
    var.bound=(bound*Ybar)^2
  }
  
  if (method=="d") 
  { 
    quan=qnorm(1-alpha/2)
    var.bound=(bound/quan)^2
  }
  
  if (method=="r") 
  {
    quan=qnorm(1-alpha/2)
    var.bound=(bound*Ybar/quan)^2
  }
  return(var.bound)
}
```

## Examples 
### 4.1
```r
source("Code/ci.r")
source("Code/srs.r")
source("Code/stratified mean.r")
source("Code/stratified prop.r")


########## Input data  #########################################
Nh=c(23560, 148420)
nh=c(300, 250)
yh=c(15180, 9856)
s2h=c(3972^2, 2546^2)
alpha=0.10

######### data analysis  ###########################
ex1.result=stra.srs.mean1(Nh, nh, yh, s2h, alpha)
print(ex1.result)
```

### 4.2
```r
### Example 3: Example 4.2  ####################################
source("Code/ci.r")
source("Code/srs.r")
source("Code/stratified mean.r")
source("Code/stratified prop.r")


########## Input data  #########################################
N=100000
Wh=c(0.281, 0.322, 0.213, 0.184)
nh=c(400, 650, 600, 350)
ph=c(0.083, 0.174, 0.310, 0.464)
alpha=0.05


######### data analysis  ###########################
ex3.result1=stra.srs.prop1(Nh=Wh*N, nh, ah=nh*ph, alpha)
print(ex3.result1)

ex3.result2=stra.srs.prop2(Nh=Wh*N, nh, ah=nh*ph, alpha)
print(ex3.result2)
```

### 4.4
```r
### Example 4: Example 4.4 ######################################
source("Code/ci.r")
source("Code/srs.r")
source("Code/stratified mean.r")
source("Code/stratified prop.r")
source("Code/stratified size.r")


########## Input data  #########################################
n=550
Nh=c(23560, 148420)
S2h=c(3000^2, 2500^2)
Ch=c(1, 2)

Wh=Nh/sum(Nh)

######### data analysis  ###########################
re1=strata.size(n, Wh, S2h, Ch=NULL, allocation="Prop")
print(re1)

re2=strata.size(n, Wh, S2h, Ch, allocation="Opt")
print(re2)

re3=strata.size(n, Wh, S2h, Ch=NULL, allocation="Neyman")
print(re3)
```

### 4.7
```r
### Example 5: Example 4.7 ######################################
source("Code/ci.r")
source("Code/srs.r")
source("Code/stratified mean.r")
source("Code/stratified prop.r")
source("Code/stratified size.r")


########## Input data  #########################################
Nh=c(23560, 148420)
S2h=c(3000^2, 2500^2)
Ch=c(1, 2)

method="d"
bound=200
Ybar=NULL
alpha=0.05

######### data analysis  ###########################
re1=strata.mean.size(Nh, S2h, Ch=NULL, allocation="Prop", method, bound, Ybar, alpha)
print(re1)

re2=strata.mean.size(Nh, S2h, Ch, allocation="Opt", method, bound, Ybar, alpha)
print(re2)

re3=strata.mean.size(Nh, S2h, Ch=NULL, allocation="Neyman", method, bound, Ybar, alpha)
print(re3)
```

# Chapter 6 Ratio and Regression Estimation
## Functions
### Estimation of Ratio
Ratio is defined as 
$$R = \frac{\bar Y}{\bar X} = \frac{Y_T}{X_T}$$

1. Point Estimation$$\hat R = \frac{\bar y}{\bar x}$$
2. AUE $$\lim_{n\to \infty} E(\hat R) = R$$
3. Variance of Estimation 
   > **Proposition** :$$ MSE(\hat R) \overset{AUE}{\simeq} Var(\hat R) \overset{n\to \infty}\simeq \frac{1-f}{n\bar X^2} \frac{1}{N-1}\sum_{i=1}^N (Y_i - RX_i)^2$$
   > Where: $$\begin{aligned}S_g^2 &\overset{0}{=} \frac{1}{N-1} \sum_{i=1}^{N} (Y_i - R X_i)^2\\&\overset{1}{=} S_y^2 + R^2 S_x^2 - 2R S_{yx}\\&\overset{2}{=} \bar Y^2 (C_y^2 + C_x^2 - 2C_{yx})\end{aligned}$$
4. Estimation of Variance
  **Method 1** When $\bar X$ is given
  $$\begin{aligned}\widehat{\text{Var}}_1(\hat{R}) &\overset{0}{=} \frac{1-f}{n} \cdot \frac{1}{\bar{X}^2} \cdot \frac{1}{n-1} \sum_{i=1}^{n} (y_i - \hat{R} x_i)^2\\&\overset{1}{=} \frac{1-f}{n} \cdot \frac{1}{\bar{X}^2} \cdot (S_y^2 + \hat{R}^2 S_x^2 - 2 \hat{R} S_{yx})\end{aligned}$$

  **Method 2** When $\bar X$ is unknown, we use $\bar x$ from the sample

 $$\begin{aligned}
    \widehat{\text{Var}}_2(\hat{R}) &\overset{0}{=} \frac{1-f}{n} \cdot \frac{1}{\bar{X}^2} \cdot \frac{1}{n-1} \sum_{i=1}^{n} (y_i - \hat{R} x_i)^2\\
    &\overset{1}{=} \frac{1-f}{n} \cdot \frac{1}{\bar{X}} \cdot (S_y^2 + \hat{R}^2 S_x^2 - 2 \hat{R} S_{yx})\end{aligned}
    $$

 Note: When $\bar X$ is given, we can use both methods 1 and 2. When $\bar X$ is unknown, use method 2.
    
5. Confidence Interval

```r
ratio=function(y.sample, x.sample, N=NULL, auxiliary=FALSE, Xbar=NULL, alpha)
{
  n=length(y.sample)
  f=ifelse(is.null(N), 0, n/N)
  nf=(1-f)/n

  ybar=mean(y.sample)
  xbar=mean(x.sample)
  
  sy2 =var(y.sample)
  sx2 =var(x.sample)
  syx =cov(y.sample, x.sample)
  
  cy2 =nf*sy2/(ybar^2)
  cx2 =nf*sx2/(xbar^2)
  cyx =nf*syx/(ybar*xbar)
  
  ratio.est=ybar/xbar
  
  if(auxiliary==FALSE)
  {
    ratio.var=(nf/xbar^2)*(sy2+ratio.est^2*sx2-2*ratio.est*syx)
    ratio.sd =sqrt(ratio.var)
  }
  else
  {
    ratio.var=(nf/Xbar^2)*(sy2+ratio.est^2*sx2-2*ratio.est*syx)
    ratio.sd =sqrt(ratio.var)
  }  
  
  
  ### CI: Method 1 ####################################
  ci1=conf.interval(ratio.est, ratio.sd, alpha)
  left1 =ci1$left
  right1=ci1$right
  
  
  ### CI: Method 2 ####################################
  quan=qnorm(1-alpha/2)
  
  est2=1-quan^2*cyx
  var2=(cy2+cx2-2*cyx)-quan^2*(cy2*cx2-cyx^2)
  
  ci2=conf.interval(est2, sqrt(var2), alpha)
  left2 =ratio.est*(ci2$left)/(1-quan^2*cx2)
  right2=ratio.est*(ci2$right)/(1-quan^2*cx2)
  
  ### CI: Method 3 ####################################
  var3=ratio.est^2*(cy2+cx2-2*cyx)
  
  ci3=conf.interval(ratio.est, sqrt(var3), alpha)
  left3 =ci3$left
  right3=ci3$right
  
  ratio.ci=t(cbind(c(left1, right1), c(left2, right2), c(left3, right3)))
  colnames(ratio.ci)=c("Left", "Right")
  rownames(ratio.ci)=c("Classic", "Exact", "Exact2")
  return(list(ratio.est=ratio.est, ratio.var=ratio.var, ratio.sd=ratio.sd, ratio.ci=as.data.frame(ratio.ci)))
}
```
### SRSF (Simple Random Sampling with Fixed Ratio Estimation) of Population Mean $\bar Y$

1. **Estimator for the Population Mean**:
 $$
   \bar{y}_R = \frac{\bar{y}}{\bar{x}} \cdot \bar{X} = \hat{R} \cdot \bar{X}
   $$

2. **Expected Value of the Estimator**:
 $$
   E(\bar{y}_R) = E(\hat{R}) \cdot \bar{X} \approx R \cdot \bar{X} = \bar{Y} \quad (\text{AUE})
   $$

3. **Variance of the Estimator**:
 $$
   \text{Var}(\bar{y}_R) = \bar{X}^2 \cdot \text{Var}(\hat{R})
   $$

4. **Estimated Variance of the Estimator**:
 $$
   \widehat{\text{Var}}(\bar{y}_R) = \bar{X}^2 \cdot \widehat{\text{Var}}_1(\hat{R})
   $$

5. **Confidence Interval**:
 $$
   \text{CI} = \left[ \bar{X} \cdot \text{left}, \, \bar{X} \cdot \text{right} \right]
   $$


```r
ratio.mean=function(y.sample, x.sample, N=NULL, Xbar, alpha)
{ 
  ratio.result=ratio(y.sample, x.sample, N, auxiliary=TRUE, Xbar, alpha)
  ratio.est=ratio.result$ratio.est
  ratio.var=ratio.result$ratio.var
  ratio.ci =ratio.result$ratio.ci
  
  ybarR.est=Xbar*ratio.est              
  ybarR.var=Xbar^2*ratio.var
  ybarR.sd =sqrt(ybarR.var)
  ybarR.ci =Xbar*ratio.ci
  
  return(list(ybarR.est=ybarR.est, ybarR.var=ybarR.var, ybarR.sd=ybarR.sd, 
              ybarR.ci=as.data.frame(ybarR.ci)))
}
```
### SRSF Estimation of Population Total $ Y_T $


1. **Estimator for the Population Total**:
 $$
   \hat{Y}_R = N \cdot \bar{y}_R
   $$

2. **Approximately Unbiased Estimator (AUE)**:
 $$
   E(\hat{Y}_R) \approx Y_T
   $$

3. **Variance of the Estimator**:
 $$
   \text{Var}(\hat{Y}_R) = N^2 \cdot \text{Var}(\bar{y}_R)
   $$

4. **Estimated Variance of the Estimator**:
 $$
   \widehat{\text{Var}}(\hat{Y}_R) = N^2 \cdot \widehat{\text{Var}}(\bar{y}_R)
   $$

5. **Confidence Interval**:
    $$
   \text{CI} = \left[ N \cdot \text{left}, \, N \cdot \text{right} \right]
   $$
```r
ratio.total=function(y.sample, x.sample, N, Xbar, alpha)
{
  ybarR.result=ratio.mean(y.sample, x.sample, N, Xbar, alpha)
  ybarR.est=ybarR.result$ybarR.est
  ybarR.var=ybarR.result$ybarR.var
  ybarR.ci =ybarR.result$ybarR.ci
  
  ytotal.est=N*ybarR.est              
  ytotal.var=N^2*ybarR.var
  ytotal.sd =sqrt(ytotal.var)
  ytotal.ci =N*ybarR.ci
  
  return(list(ytotal.est=ytotal.est, ytotal.var=ytotal.var, ytotal.sd=ytotal.sd, 
              ytotal.ci=as.data.frame(ytotal.ci)))
}
```

### Design Efficiency
When comparing complex methods to simple methods, design efficiency is defined as the fraction.
$$\text{Deff} = \frac{Var(\bar y_R)}{Var(\bar y)} = \begin{cases} <1 & \bar y_R \text{ is more efficient}\\ \geq 1 & \bar y \text{ is more efficient} \end{cases}$$
When $$\rho > \frac{C_x}{2C_y}$$
$\bar y_R$ if more efficient then $\bar y$.
When $Y$ and $X$ are highly correlated, $\bar y_R$ is more efficient than $\bar y$.

```r
deff=function(var.result)
{
deff.vector=var.result/var.result[1]
deff.result=cbind(var.result, deff.vector)
deff.result=round(deff.result,5)

colnames(deff.result)=c("Var", "Deff")
return(deff.result=as.data.frame(deff.result))
}


```

### Determining Sample Size
**Step 1**
When given bound $(V,C,d,r)$ of $\bar Y$, determine the simple sample size $n_{\text{simple}}$
Using the function `size.mean`
**Step 2**
Determine the ratio sample size $n_{R}$
$$n_R = \text{Deff} \cdot n_{\text{simple} }$$
Use `deff=function(var.result)` to calculate the design efficiency and use `deff.size=function(deff.result, n.simple)` to calculate the size.
```
deff.size=function(deff.result, size1)
{
  size2=size1*deff.result$Deff
  deff.result$Size=round(size2)
return(deff.result)
}
```
### Regression Estimation of Population Mean $\bar Y$
#### Case 1: $\beta = \beta_0$ is constant

1. Estimator for the Population Mean  
 $$
   \bar{y}_{lr}(\beta_0) = \bar{y} + \beta_0 (\bar{X} - \bar{x})
   $$

2. Unbiased Estimator  
 $$
   E(\bar{y}_{lr}) = \bar{Y} + \beta_0 (\bar{X} - E(\bar{x})) = \bar{Y} \quad \text{(UE)}
   $$

3. Variance of the Estimator  
 $$
   \text{Var}(\bar{y}_{lr}) = \frac{1-f}{n} \left( S_y^2 + \beta_0^2 S_x^2 - 2 \beta_0 S_{yx} \right)
   $$

   >Minimum Variance Condition  
   >$$\text{Minimum when } \beta_0 = B = \frac{S_{yx}}{S_x^2}\Rightarrow \text{Var}_{\text{min}} = \frac{1-f}{n} S_e^2$$
   >Here $B$ is the population regression coefficient of $X$ on $Y$. $$B = \frac{S_{yx}}{S_x^2}$$
   >$$\text{Var}_{\text{min}}(\bar y_{lr}) = \frac{1-f}{n} S_y^2(1-\rho^2)$$
   >$$S_e^2 \triangleq S_y^2(1-\rho^2),\qquad \rho = \frac{S_{yx}}{Sy S_x}$$

4. Estimated Variance of the Estimator
 $$
   \widehat{\text{Var}}(\bar{y}_{lr}) = \frac{1-f}{n} \left( s_y^2 + \beta_0^2 s_x^2 - 2 \beta_0 s_{yx} \right)
   $$
5. Confidence Interval  
 $$
   \left[ \bar{y}_{lr} \pm z_\alpha \sqrt{\widehat{\text{Var}}(\bar{y}_{lr})} \right]
   $$

---

#### Case 2: $\beta = \hat b$ is the sample regression coefficient of $x$ and $y$
$$\beta = \hat b = \frac{s_{yx}}{s_x^2}$$

1. Estimator for the Population Mean  
 $$
   \bar{y}_{lr} = \bar{y} + \hat{b} (\bar{X} - \bar{x})
   $$

2. Approximate Unbiased Estimator
 $$
   E(\bar{y}_{lr}) \approx \bar{Y} \quad \text{(AUE)}
   $$

3. Mean Squared Error (MSE) and Variance  
 $$
   \text{MSE}(\bar{y}_{lr}) \approx \text{Var}(\bar{y}_{lr}) \approx \frac{1-f}{n} S_e^2
   $$
   >This is the theoretically minimum variance estimator.

4. Estimated Variance of the Estimator  
 $$
   \widehat{\text{Var}}(\bar{y}_{lr}) = \frac{1-f}{n} s_e^2 = \frac{1-f}{n} \cdot \frac{n-1}{n-2} \left( s_y^2 - \frac{s_{yx}^2}{s_x^2} \right)
   $$ 
 where
 $$
   s_e^2 = \frac{n-1}{n-2} \left( s_y^2 - \frac{s_{yx}^2}{s_x^2} \right)
   $$

```r
regression.mean=function(y.sample, x.sample, N=NULL, Xbar, alpha, method="Min", beta0=NULL)
{
  n=length(y.sample)
  f=ifelse(is.null(N), 0, n/N)
  nf=(1-f)/n
  
  ybar=mean(y.sample)
  xbar=mean(x.sample)
  
  sy2 =var(y.sample)
  sx2 =var(x.sample)
  syx =cov(y.sample, x.sample)
  
  if (method=="Min")
  {
    beta=syx/sx2
    ybar.reg.est=ybar+beta*(Xbar-xbar)
    ybar.reg.var=nf*(n-1)/(n-2)*(sy2-syx^2/sx2)
    ybar.reg.sd =sqrt(ybar.reg.var)
    
    ci=conf.interval(ybar.reg.est, ybar.reg.sd, alpha)
    left =ci$left
    right=ci$right
    
    ybar.reg.result=matrix(c(ybar.reg.est, ybar.reg.var, ybar.reg.sd, left, right), nrow=1)
    colnames(ybar.reg.result)=c("Est", "Var", "SD", "Left", "Right")
    rownames(ybar.reg.result)=c("Mean_Reg")
  }
  
  if (method=="Constant")
  {
    beta=beta0
    ybar.reg.est=ybar+beta*(Xbar-xbar)
    ybar.reg.var=nf*(sy2+beta^2*sx2-2*beta*syx)
    ybar.reg.sd =sqrt(ybar.reg.var)
    
    ci=conf.interval(ybar.reg.est, ybar.reg.sd, alpha)
    left =ci$left
    right=ci$right
    
    ybar.reg.result=matrix(c(ybar.reg.est, ybar.reg.var, ybar.reg.sd, left, right), nrow=1)
    colnames(ybar.reg.result)=c("Est", "Var", "SD", "Left", "Right")
    rownames(ybar.reg.result)=c("Mean_Reg")
  }
  return(ybar.reg.result=as.data.frame(ybar.reg.result))
}
```
### Regression Estimation of Population Total $Y_T$
Notice that $$\text{mean }\quad \bar y_{lr} \overset{N}{\longrightarrow} \hat y_{lr} \quad \text{total}$$

```r
regression.total=function(y.sample, x.sample, N=NULL, Xbar, alpha, method="Min", beta0=NULL)
{
  ybar.reg.result=regression.mean(y.sample, x.sample, N, Xbar, alpha, method, beta0)
  ybar.reg.est  =ybar.reg.result$Est
  ybar.reg.var  =ybar.reg.result$Var
  ybar.reg.left =ybar.reg.result$Left
  ybar.reg.right=ybar.reg.result$Right
  
  ytotal.reg.est  =N*ybar.reg.est              
  ytotal.reg.var  =N^2*ybar.reg.var
  ytotal.reg.sd   =sqrt(ytotal.reg.var)
  ytotal.reg.left =N*ybar.reg.left
  ytotal.reg.right=N*ybar.reg.right
  
  ytotal.reg.result=matrix(c(ytotal.reg.est, ytotal.reg.var, ytotal.reg.sd, ytotal.reg.left, ytotal.reg.right), nrow=1)
  colnames(ytotal.reg.result)=c("Est", "Var", "SD", "Left", "Right")
  rownames(ytotal.reg.result)=c("Total_Reg")
  
  return(ytotal.reg.result=as.data.frame(ytotal.reg.result))
}
```
## Examples
### 5.3
```r
## Example 1: Example 5.3  ######################################
source("Code/ci.r")
source("Code/ratio.r")

########## Input data  #########################################
mydata=read.csv("Data/car.csv")
print(mydata)

y.sample=mydata$y
x.sample=mydata$x

N=NULL
auxiliary=FALSE
Xbar=NULL
alpha=0.1

######### data analysis  ###########################
re1=ratio(y.sample, x.sample, N, auxiliary, Xbar, alpha)
print(re1)
```
### 5.4
```r
## Example 2: Example 5.4  ######################################
source("Code/ci.r")
source("Code/srs.r")
source("Code/ratio.r")
source("Code/ratio mean.r")
source("Code/ratio total.r")
source("Code/deff.r")

########## Input data  ########################################
mydata=read.csv("Data/salary.csv")
print(mydata)

y.sample=mydata$y
x.sample=mydata$x

N=687
Xbar=70523.16/N
alpha=0.05

######### plot #####################################
plot(mydata)
######### data analysis  ###########################
##Mean##
mean.simple.result=srs.mean(N, y.sample, alpha)
print(mean.simple.result)

mean.ratio.result=ratio.mean(y.sample, x.sample, N, Xbar, alpha)
print(mean.ratio.result)

var.result=c(mean.simple.result$ybar.var, mean.ratio.result$ybarR.var)
deff.result=deff(var.result)
rownames(deff.result)=c("Simple", "Ratio")
print(deff.result)
####################################
##Total##
total.simple.result=srs.total(N, y.sample, alpha)
print(total.simple.result)

total.ratio.result=ratio.total(y.sample, x.sample, N, Xbar, alpha)
print(total.ratio.result)

var.result=c(total.simple.result$ytot.var, total.ratio.result$ytotal.var)
deff.result=deff(var.result)
rownames(deff.result)=c("Simple", "Ratio")
print(deff.result)
```
### 5.7
```r
## Example 4: Exercise 5.7  ######################################
source("Code/ci.r")
source("Code/srs.r")
source("Code/srs size.r")
source("Code/ratio.r")
source("Code/ratio mean.r")
source("Code/ratio total.r")
source("Code/deff.r")

########## Input data  #########################################
mydata=read.csv("Data/rabit.csv")
print(mydata)

y.sample=mydata$y
x.sample=mydata$x

N=100
Xbar=3.1
alpha=0.05


######### data analysis  ###########################
mean.simple.result=srs.mean(N, y.sample, alpha)
print(mean.simple.result)

mean.ratio.result=ratio.mean(y.sample, x.sample, N, Xbar, alpha)
print(mean.ratio.result)

var.result=c(mean.simple.result$ybar.var, mean.ratio.result$ybarR.var)
deff.result=deff(var.result)
print(deff.result)

n.simple=size.mean(N, Mean.his=NULL, Var.his=var(y.sample), method="d", bound=0.05, alpha)$size
size.result=deff.size(deff.result, n.simple)

rownames(size.result)=c("Simple", "Ratio")
print(size.result)
```

### 5.6
```r
## Example 5: Example 5.6  ######################################
source("Code/ci.r")
source("Code/srs.r")
source("Code/ratio.r")
source("Code/ratio mean.r")
source("Code/ratio total.r")
source("Code/reg mean.r")
source("Code/reg total.r")
source("Code/deff.r")

########## Input data  #########################################
mydata=read.csv("Data/salary.csv")
print(mydata)

y.sample=mydata$y
x.sample=mydata$x

N=687
Xbar=70523.16/N
alpha=0.05

######### data analysis  #######################################################
total.simple.reult=srs.total(N, y.sample, alpha)
print(total.simple.reult)

total.ratio.result=ratio.total(y.sample, x.sample, N, Xbar, alpha)
print(total.ratio.result)

total.reg.result=regression.total(y.sample, x.sample, N, Xbar, alpha, method="Min", beta0=NULL)
print(total.reg.result)

var.result=c(total.simple.reult$ytot.var, total.ratio.result$ytotal.var, total.reg.result$Var)
deff.result=deff(var.result)
rownames(deff.result)=c("Simple", "Ratio", "Regression")
print(deff.result)
```

### 5.7
```r
## Example 6: Exercise 5.7  ######################################
source("Code/ci.r")
source("Code/srs.r")
source("Code/srs size.r")
source("Code/ratio.r")
source("Code/ratio mean.r")
source("Code/ratio total.r")
source("Code/reg mean.r")
source("Code/reg total.r")
source("Code/deff.r")

########## Input data  #########################################
mydata=read.csv("Data/rabit.csv")
print(mydata)

y.sample=mydata$y
x.sample=mydata$x

N=100
Xbar=3.1
alpha=0.05

######### data analysis  #######################################################
mean.simple.result=srs.mean(N, y.sample, alpha)
print(mean.simple.result)

mean.reg.result=regression.mean(y.sample, x.sample, N, Xbar, alpha, method="Min", beta0=NULL)
print(mean.reg.result)

var.result=c(mean.simple.result$ybar.var, mean.reg.result$Var)
deff.result=deff(var.result)

n.simple=size.mean(N, Mean.his=NULL, Var.his=var(y.sample), method="d", bound=0.05, alpha)$size
size.result=deff.size(deff.result, n.simple)

rownames(size.result)=c("SRS", "Reg")
print(size.result)
```









# Chapter 6.2 Stratified Ratio and Regression
### Stratified: Separate Ratio Estimation of Population Mean $\bar Y$›

1. **Estimator for the Population Mean**
 $$
   \bar{y}_{RS} = \sum_h W_h \bar{y}_{Rh} = \sum_h W_h \left( \frac{\bar{y}_h}{\bar{x}_h}  \cdot \bar{X}_h\right)
   $$
   >Notice that $$\bar y_{Rh} =   \frac{\bar{y}_h}{\bar{x}_h}  \cdot \bar{X}_h$$ is the ratio estimator of the $ h $-th stratum.

2. **Approximate Unbiasedness**
 $$
   E(\bar{y}_{RS}) \approx \bar{Y} \quad (\text{AUE})
   $$

3. **Variance of the Estimator**
 $$
   \text{Var}(\bar{y}_{RS}) \approx \sum_h W_h^2 \frac{1-f_h}{n_h} \left( S_{y_h}^2 + R_h^2 S_{x_h}^2 - 2R_h S_{yxh} \right)
   $$

4. **Estimated Variance of the Estimator**
 $$
   \widehat{\text{Var}}(\bar{y}_{RS}) \approx \sum_h W_h^2 \frac{1-f_h}{n_h} \left( s_{y_h}^2 + \hat{R}_h^2 s_{x_h}^2 - 2\hat{R}_h s_{yxh} \right)
   $$
 where $ \hat{R}_h = \frac{\bar{y}_h}{\bar{x}_h} $
```r
separate.ratio.mean=function(Nh, y.sample, x.sample, stra.index, Xbarh, alpha)
{
  stra.num=length(Nh)
  Wh=Nh/sum(Nh)

  yh.est  =rep(0, stra.num)
  yh.var  =rep(0, stra.num)
  yh.sd   =rep(0, stra.num)
  yh.left =rep(0, stra.num)
  yh.right=rep(0, stra.num)
  
  for (h in 1:stra.num)
  {
    y.hth=y.sample[stra.index==h]
    x.hth=x.sample[stra.index==h]
    stra.ratio=ratio.mean(y.hth, x.hth, Nh[h], Xbarh[h], alpha)
    
    yh.est[h]  =stra.ratio$ybarR.est
    yh.var[h]  =stra.ratio$ybarR.var
    yh.sd[h]   =stra.ratio$ybarR.sd
    
    yh.ci      =stra.ratio$ybarR.ci
    yh.ci.left =yh.ci$Left
    yh.ci.right=yh.ci$Right
    yh.left[h] =yh.ci.left[1]
    yh.right[h]=yh.ci.right[1]
  }
  stra.result=cbind(Nh, Wh, yh.est, yh.var, yh.sd, yh.left, yh.right)
  
  yRS.est=sum(Wh*yh.est)
  yRS.var=sum(Wh^2*yh.var)
  yRS.sd =sqrt(yRS.var)
  
  yRS.ci=conf.interval(yRS.est, yRS.sd, alpha)
  yRS.left =yRS.ci$left
  yRS.right=yRS.ci$right
  
  yRS.result=matrix(c(yRS.est, yRS.var, yRS.sd, yRS.left, yRS.right), nrow=1)
  colnames(yRS.result)=c("Est", "Var", "SD", "Left", "Right")
  rownames(yRS.result)="Mean_RS"
  return(list(stra.result=as.data.frame(stra.result), yRS.result=as.data.frame(yRS.result)))
}


separate.ratio.total=function(Nh, y.sample, x.sample, stra.index, Xbarh, alpha)
{
  N=sum(Nh)
  Wh=Nh/sum(Nh)
  
  mean.RS.result=separate.ratio.mean(Nh, y.sample, x.sample, stra.index, Xbarh, alpha)
  RS.stra=mean.RS.result$stra.result
  RS.mean=mean.RS.result$yRS.result
  
  yh.totR.est  =Nh*RS.stra$yh.est
  yh.totR.var  =Nh^2*RS.stra$yh.var
  yh.totR.sd   =sqrt(yh.totR.var)
  yh.totR.left =Nh*RS.stra$yh.left
  yh.totR.right=Nh*RS.stra$yh.right

  stra.result=cbind(Nh, Wh, yh.totR.est, yh.totR.var, yh.totR.sd, yh.totR.left, yh.totR.right)
  
  ytot.RS.est  =N*RS.mean$Est             
  ytot.RS.var  =N^2*RS.mean$Var
  ytot.RS.sd   =sqrt(ytot.RS.var)
  ytot.RS.left =N*RS.mean$Left
  ytot.RS.right=N*RS.mean$Right
  
  ytot.RS.result=matrix(c(ytot.RS.est, ytot.RS.var, ytot.RS.sd, ytot.RS.left, ytot.RS.right), nrow=1)
  colnames(ytot.RS.result)=c("Est", "Var", "SD", "Left", "Right")
  rownames(ytot.RS.result)="TOTAL_RS"
  return(list(stra.result=as.data.frame(stra.result), ytot.RS.result=as.data.frame(ytot.RS.result)))
}
```

### Stratified: Combined Ratio Estimation of Population Mean $\bar Y$

1. **Estimator for the Population Mean**  
 $$
   \bar{y}_{RC} = \frac{\bar{y}_{st}}{\bar{x}_{st}} \cdot \bar{X} = \hat{R}_c \cdot \bar{X}
   $$

2. **Approximate Unbiasedness**  
 $$
   E(\bar{y}_{RC}) \approx \bar{Y} \quad (\text{AUE})
   $$

3. **Variance of the Estimator**  
 $$
   \text{Var}(\bar{y}_{RC}) = \sum_h W_h^2 \frac{1-f_h}{n_h} \left( S_{y_h}^2 + R_h^2 S_{x_h}^2 - 2R_h S_{yx_h} \right)
   $$

4. **Estimated Variance of the Estimator**  
 $$
   \widehat{\text{Var}}(\bar{y}_{RC}) = \sum_h W_h^2 \frac{1-f_h}{n_h} \left( s_{y_h}^2 + \hat{R}_c^2 s_{x_h}^2 - 2\hat{R}_c s_{yx_h} \right)
   $$
 where:
 $$
   \hat{R}_c = \frac{\bar{y}_{st}}{\bar{x}_{st}}
   $$

```r
combined.ratio.mean=function(Nh, y.sample, x.sample, stra.index, Xbar, alpha)
{
  yst.result=stra.srs.mean2(Nh, y.sample, stra.index, alpha)$mean.result
  xst.result=stra.srs.mean2(Nh, x.sample, stra.index, alpha)$mean.result
  
  ratio.est=yst.result$mean.est/xst.result$mean.est
  yRC.est=Xbar*ratio.est
  
  stra.num=length(Nh)
  Wh=Nh/sum(Nh)
  
  nh  =rep(0, stra.num)
  sy2 =rep(0, stra.num)
  sx2 =rep(0, stra.num)
  syx =rep(0, stra.num)

  for (h in 1:stra.num)
  {
  y.hth=y.sample[stra.index==h]
  x.hth=x.sample[stra.index==h]
    
  nh[h]=length(y.hth)

  sy2[h] =var(y.hth)
  sx2[h] =var(x.hth)
  syx[h]=cov(y.hth, x.hth)
  }
  
  fh=nh/Nh
  nf=(1-fh)/nh
  
  stra.result=cbind(Nh, Wh, nh, fh)
  
  yRC.var=sum(Wh^2*nf*(sy2+ratio.est^2*sx2-2*ratio.est*syx))
  yRC.sd =sqrt(yRC.var)

  yRC.ci=conf.interval(yRC.est, yRC.sd, alpha)
  yRC.left =yRC.ci$left
  yRC.right=yRC.ci$right
  
  yRC.result=matrix(c(yRC.est, yRC.var, yRC.sd, yRC.left, yRC.right), nrow=1)
  colnames(yRC.result)=c("Est", "Var", "SD", "Left", "Right")
  rownames(yRC.result)=c("Mean_RC")
  return(list(stra.result=as.data.frame(stra.result), yRC.result=as.data.frame(yRC.result)))
}


combined.ratio.total=function(Nh, y.sample, x.sample, stra.index, Xbar, alpha)
{
  N=sum(Nh)

  mean.RC.result=combined.ratio.mean(Nh, y.sample, x.sample, stra.index, Xbar, alpha)
  RC.stra=mean.RC.result$stra.result
  RC.mean=mean.RC.result$yRC.result
  
  ytot.RC.est  =N*RC.mean$Est             
  ytot.RC.var  =N^2*RC.mean$Var
  ytot.RC.sd   =sqrt(ytot.RC.var)
  ytot.RC.left =N*RC.mean$Left
  ytot.RC.right=N*RC.mean$Right
  
  ytot.RC.result=matrix(c(ytot.RC.est, ytot.RC.var, ytot.RC.sd, ytot.RC.left, ytot.RC.right), nrow=1)
  colnames(ytot.RC.result)=c("Est", "Var", "SD", "Left", "Right")
  rownames(ytot.RC.result)=c("TOTAL_RC")
  return(list(stra.result=as.data.frame(RC.stra), ytot.RC.result=as.data.frame(ytot.RC.result)))
}
```

### Separate Regression Estimation of Population Mean $\bar Y$

#### Case I: When $\beta_h$ is constant
1. **Estimator for the Population Mean**  
 $$
   \bar{y}_{lrS} = \sum_hW_h \bar y_{lrh }=\sum_h W_h \left( \bar{y}_h + \beta_h (\bar{X}_h - \bar{x}_h) \right)
   $$
   > Notice that $$\bar y_{lrh} = \bar{y}_h + \beta_h (\bar{X}_h - \bar{x}_h)$$ is the regression estimator of the $ h $-th stratum.
2. **Unbiasedness**  
 $$
   E(\bar{y}_{lrS}) = \bar{Y} \quad (\text{UE})
   $$

3. **Variance of the Estimator**  
 $$
 \text{Var}(\bar{y}_{lrS}) = \sum_h W_h^2 \frac{1-f_h}{n_h} \left( S_{y_h}^2 + \beta_h^2 S_{x_h}^2 - 2\beta_h S_{yx_h} \right)
 $$

   > **Minimum Variance Condition**  
      >When $ \beta_h = B_h = \frac{S_{yx_h}}{S_{x_h}^2} $:  
      >$$
      >\text{Var}_{\text{min}} = \sum_h W_h^2 \frac{1-f_h}{n_h} S_{eh}^2
      >$$
      >where:
      >$$
      >S_{eh}^2 = S_{y_h}^2 (1 - \rho_h^2)
      >$$

4. **Estimated Variance of the Estimator**  
 $$
   \widehat{\text{Var}}(\bar{y}_{lrS}) = \sum_h W_h^2 \frac{1-f_h}{n_h} \left( s_{y_h}^2 + \hat{\beta}_h^2 s_{x_h}^2 - 2\hat{\beta}_h s_{yx_h} \right)
   $$

---

#### Case II: When $ \beta_h = \hat{b}_h = \frac{S_{yx_h} }{S_{x_h}^2} $ (Regression Coefficient)

1. Estimator for the Population Mean
 $$
   \bar{y}_{lrS} = \sum_h W_h \left( \bar{y}_h + \hat{b}_h (\bar{X}_h - \bar{x}_h) \right)
   $$

2. **Asymptotically Unbiased Estimator**  
 $$
   E(\bar{y}_{lrS}) \approx \bar{Y} \quad (\text{AUE})
   $$

3. **Variance of the Estimator**  
 $$
   \text{Var}(\bar{y}_{lrS}) \approx \sum_h W_h^2 \frac{1-f_h}{n_h} S_{y_h}^2 (1 - \rho_h^2)
   $$

4. **Estimated Variance of the Estimator**  
 $$
   \widehat{\text{Var}}(\bar{y}_{lrS}) \approx \sum_h W_h^2 \frac{1-f_h}{n_h} \frac{n_h-1}{n_h-2} \left( s_{y_h}^2 - \frac{s_{yx_h}}{s_{x_h}^2} \right)^2
   $$

```r
# Write this as homework
seperate.regression.mean=function(Nh, y.sample, x.sample, stra.index, Xbarh, alpha, method = "Min", beta0 = NULL)
{
    ## Your Code Here
    return(list(stra.result=as.data.frame(stra.result), ylrS.result=as.data.frame(ylrS.result)))
}
seperate.regression.total = function(Nh, y.sample, x.sample, stra.index, Xbarh, alpha, method = "Min", beta0 = NULL)
{
    ## Your Code Here
    return(list(stra.result = as.data.frame(stra.result), YlrS.result = as.data.frame(Ytotal.result)))
}
```

### Combined Regression Estimation of Population Mean $\bar Y$


#### Case I: When $\beta$ is constant

1. **Estimator for the Population Mean**  
 $$
   \bar{y}_{lrC} = \bar{y}_{st} + \beta (\bar{X} - \bar{x}_{st})
   $$

2. **Unbiasedness**  
 $$
   E(\bar{y}_{lrC}) = \bar{Y} \quad (\text{UE})
   $$

3. **Variance of the Estimator**  
 $$
   \text{Var}(\bar{y}_{lrC}) = \sum_h W_h^2 \frac{1-f_h}{n_h} \left( S_{yh}^2 + \beta^2 S_{xh}^2 - 2\beta S_{yxh} \right)
   $$

   >**Minimum Variance Condition**  
      >When $$ \beta = B_c = \frac{\sum_h W_h^2 \frac{1-f_h}{n_h} S_{yxh}}{\sum_h W_h^2 \frac{1-f_h}{n_h} S_{xh}^2} $$ 
      >
      >The Variance achieves its minimum.

5. **Estimated Variance of the Estimator**  
 $$
   \widehat{\text{Var}}(\bar{y}_{lrC}) = \sum_h W_h^2 \frac{1-f_h}{n_h} \left( s_{yh}^2 + \hat{\beta}^2 s_{xh}^2 - 2\hat{\beta} s_{yxh} \right)
   $$

---

#### Case II 
**When** $$ \beta = \hat{b}_c = \frac{\sum_h W_h^2 \frac{1-f_h}{n_h} S_{yx_h}}{\sum_h W_h^2 \frac{1-f_h}{n_h} S_{x_h}^2} $$  
1. **Estimator for the Population Mean**  
 $$
   \bar{y}_{lrC} = \bar{y}_{st} + \hat{b}_c (\bar{X} - \bar{x}_{st})
   $$

2. **Approximate Unbiasedness**  
 $$
   E(\bar{y}_{lrC}) \approx \bar{Y} \quad (\text{AUE})
   $$

3. **Variance of the Estimator**  
 $$
   \text{Var}(\bar{y}_{lrC}) \approx \sum_h W_h^2 \frac{1-f_h}{n_h} \left( S_{y_h}^2 + B_c^2 S_{x_h}^2 - 2B_c S_{yx_h} \right)
   $$

4. **Estimated Variance of the Estimator**  
 $$
   \widehat{\text{Var}}(\bar{y}_{lrC}) \approx \sum_h W_h^2 \frac{1-f_h}{n_h} \left( s_{y_h}^2 + \hat{b}_c^2 s_{x_h}^2 - 2\hat{b}_c s_{yx_h} \right)
   $$

```r
combined.regression.mean = function(Nh, y.sample, x.sample, stra.index, Xbar, alpha, method = "Min", beta0 = NULL){
    ## Your Code Here
    return(list(stra.result = as.data.frame(stra.result), ybar.lrC.result = as.data.frame(ybar.lrC.result)))
}

combined.regression.total = function(Nh, y.sample, x.sample, stra.index, Xbar, alpha, method = "Min", beta0 = NULL){
    ## Your Code Here
    return(list(stra.result = as.data.frame(stra.result), Ytotal.lrC.result = as.data.frame(Ytotal.lrC.result)))
}
```

## Examples
### 5.7
```r
## Example 7: Example 5.7  ######################################
source("Code/ci.r")
source("Code/srs.r")
source("Code/srs size.r")
source("Code/ratio.r")
source("Code/regression.r")
source("Code/stra srs.r")
source("Code/stra size.r")
source("Code/stra ratio.r")
source("Code/deff.r")
source("Code/stra regression.r")
source("Code/stra diff.r")

########## Input data  #########################################
mydata=read.csv("Data/staff.csv")
print(mydata)

y.sample  =mydata$y
x.sample  =mydata$x
stra.index=mydata$stra.index

Nh=c(135, 1228)
Xbarh=c(75650/135, 315612/1228)
Xbar=sum(Xbarh*Nh)/sum(Nh)
alpha=0.05


######### data analysis  #######################################################
total.SS.result=stra.srs.total2(Nh, y.sample, stra.index, alpha)
SS.stra=total.SS.result$stra.result
SS.total=total.SS.result$total.result
print(total.SS.result)

total.RS.result=separate.ratio.total(Nh, y.sample, x.sample, stra.index, Xbarh, alpha)
RS.stra=total.RS.result$stra.result
RS.total=total.RS.result$yRS.result
print(total.RS.result)

total.RC.result=combined.ratio.total(Nh, y.sample, x.sample, stra.index, Xbar, alpha)
RC.stra=total.RC.result$stra.result
RC.total=total.RC.result$ytot.RC.result
print(total.RC.result)

#seperate linear regression
total.slr.result = seperate.regression.total(Nh, y.sample, x.sample, stra.index, Xbarh, alpha,beta0 = 1.027)

print(total.slr.result)
SLR.total=total.slr.result$YReS.result

# combined linear regression
total.clr.result = combined.regression.total(Nh, y.sample, x.sample, stra.index, Xbar, alpha)
print(total.clr.result)
CLR.total = total.clr.result$ytot.RegC.result

# difference esimator
total.diff.result = diff.total(Nh, y.sample, x.sample, stra.index, Xbar, alpha)
print(total.diff.result)

var.result=c(SS.total$total.var, RS.total$Var, RC.total$Var)
deff.result=deff(var.result)
rownames(deff.result)=c("Stra Simple", "Sperate Ratio", "Combined Ratio")
print(deff.result)
```

# Chapter 7 Two Phase Sampling
## Functions
### Double Stratified Sampling Estimation of Population Mean $ \bar{Y}$
1. **Estimator for the Population Mean**:
 $$
   \bar{y}_{stD} = \sum_{h=1}^{L} w_h' \cdot \bar{y}_h
   $$

2. **Unbiased Estimation**:
 $$
   E(\bar{y}_{stD}) = \bar{Y} \quad (\text{UE})
   $$

3. **Variance of the Estimator**:
 $$
   \text{Var}(\bar{y}_{stD}) = \left( \frac{1}{n'} - \frac{1}{N} \right) S^2 + \sum_{h=1}^{L} \frac{1}{n_h'} (v_h' - 1) w_h' S_h^2
   $$

4. **Estimated Variance of the Estimator**:
 $$
   \widehat{\text{Var}}(\bar{y}_{stD}) = \sum_{h=1}^{L} \left( \frac{1}{n_h} - \frac{1}{n_h'} \right) w_h' s_h^2 + \left( \frac{1}{n'} - \frac{1}{N} \right) \sum_{h=1}^{L} w_h' \left( \bar{y}_h - \bar{y}_{stD} \right)^2
   $$

```r
twophase.stra.mean1=function(N=NULL, nh.1st, nh.2nd, ybarh, s2h, alpha)
{
  N.inv=ifelse(is.null(N), 0, 1/N)
  n.1st=sum(nh.1st)
  wh.1st=nh.1st/n.1st
  
  ybar.stD.est=sum(wh.1st*ybarh)
  
  ybar.stD.var1=(1/n.1st-N.inv)*sum(wh.1st*(ybarh-ybar.stD.est)^2)
  ybar.stD.var2=sum((1/nh.2nd-1/nh.1st)*wh.1st^2*s2h)
  ybar.stD.var =ybar.stD.var1+ybar.stD.var2
                
  ybar.stD.sd =sqrt(ybar.stD.var)
  
  ci.result=conf.interval(ybar.stD.est, ybar.stD.sd, alpha)
  ybar.stD.left =ci.result$left
  ybar.stD.right=ci.result$right
  
  mean.result=matrix(c(ybar.stD.est, ybar.stD.var, ybar.stD.sd, ybar.stD.left, ybar.stD.right), nrow=1)
  colnames(mean.result)=c("Est", "Var", "SD", "Left", "Right")
  rownames(mean.result)="stD_Mean"
  return(mean.result=as.data.frame(mean.result))
}
```

```r

twophase.stra.total1=function(N, nh.1st, nh.2nd, ybarh, s2h, alpha)
{
  ybar.stD.result=twophase.stra.mean1(N, nh.1st, nh.2nd, ybarh, s2h, alpha)
  ybar.stD.est  =ybar.stD.result$Est
  ybar.stD.var  =ybar.stD.result$Var
  ybar.stD.left =ybar.stD.result$Left
  ybar.stD.right=ybar.stD.result$Right
  
  ytot.stD.est  =N*ybar.stD.est              
  ytot.stD.var  =N^2*ybar.stD.var
  ytot.stD.sd   =sqrt(ytot.stD.var)
  ytot.stD.left =N*ybar.stD.left
  ytot.stD.right=N*ybar.stD.right
  
  total.result=matrix(c(ytot.stD.est, ytot.stD.var, ytot.stD.sd, ytot.stD.left, ytot.stD.right), nrow=1)
  colnames(total.result)=c("Est", "Var", "SD", "Left", "Right")
  rownames(total.result)="stD_Total"
  return(total.result=as.data.frame(total.result))
}
```
### Double Ratio Estimation of Population Mean $ \bar{Y}$
1. **Estimator for the Population Mean**:
 $$
   \bar{y}_{RD} = \hat{R} \cdot \bar{x}' = \frac{\bar{y}'}{\bar{x}'} \cdot \bar{x}'
   $$

2. **Asymptotically Unbiased Estimation**:
 $$
   E(\bar{y}_{RD}) {\approx} \bar{Y}\quad \text{AUE}
   $$

3. **Variance of the Estimator**:
 $$
   \text{Var}(\bar{y}_{RD}) = \left( \frac{1}{n'} - \frac{1}{N} \right) S_y^2 + \left( \frac{1}{n} - \frac{1}{n'} \right) (S_y^2 + R^2 S_x^2 - 2RS_{yx})
   $$

4. **Estimated Variance of the Estimator**:
 $$
   \widehat{\text{Var}}(\bar{y}_{RD}) = \left( \frac{1}{n'} - \frac{1}{N} \right) s_y^2 + \left( \frac{1}{n} - \frac{1}{n'} \right) \left( s_y^2 + \hat{R}^2 s_x^2 - 2\hat{R}s_{yx} \right)
   $$

```r
twophase.ratio.mean=function(N=NULL, n.1st, xbar.1st, y.sample, x.sample, alpha)
{ 
  N.inv=ifelse(is.null(N), 0, 1/N)  # Inverse of population size
  n.2nd=length(y.sample)  # Sample size of the second phase

  ybar=mean(y.sample)  # Mean of the study variable
  xbar=mean(x.sample)  # Mean of the auxiliary variable
  
  sy2 =var(y.sample)  # Variance of the study variable
  sx2 =var(x.sample)  # Variance of the auxiliary variable
  syx =cov(y.sample, x.sample)  # Covariance between study and auxiliary variables
  
  ratio.est=ybar/xbar  # Ratio estimator
  
  ybar.RD.est=xbar.1st*ratio.est  # Estimated mean using ratio estimator
  
  # Variance components for the estimated mean
  ybar.RD.var1=(1/n.1st-N.inv)*sy2
  ybar.RD.var2=(1/n.2nd-1/n.1st)*(sy2+ratio.est^2*sx2-2*ratio.est*syx)
  ybar.RD.var =ybar.RD.var1+ybar.RD.var2
  
  ybar.RD.sd=sqrt(ybar.RD.var)  # Standard deviation of the estimated mean
  
  # Confidence interval for the estimated mean
  ci.result=conf.interval(ybar.RD.est, ybar.RD.sd, alpha)
  ybar.RD.left =ci.result$left
  ybar.RD.right=ci.result$right
  
  # Result matrix for the estimated mean
  mean.result=matrix(c(ybar.RD.est, ybar.RD.var, ybar.RD.sd, ybar.RD.left, ybar.RD.right), nrow=1)
  colnames(mean.result)=c("Est", "Var", "SD", "Left", "Right")
  rownames(mean.result)="RD_Mean"
  return(mean.result=as.data.frame(mean.result))
}

```

```r
twophase.ratio.total=function(N, n.1st, xbar.1st, y.sample, x.sample, alpha)
{
  ybar.RD.result=twophase.ratio.mean(N, n.1st, xbar.1st, y.sample, x.sample, alpha)  # Call mean estimator
  ybar.RD.est  =ybar.RD.result$Est
  ybar.RD.var  =ybar.RD.result$Var
  ybar.RD.left =ybar.RD.result$Left
  ybar.RD.right=ybar.RD.result$Right
  
  # Calculate total estimates based on mean estimates
  ytot.RD.est  =N*ybar.RD.est              
  ytot.RD.var  =N^2*ybar.RD.var
  ytot.RD.sd   =sqrt(ytot.RD.var)
  ytot.RD.left =N*ybar.RD.left
  ytot.RD.right=N*ybar.RD.right
  
  # Result matrix for the estimated total
  total.result=matrix(c(ytot.RD.est, ytot.RD.var, ytot.RD.sd, ytot.RD.left, ytot.RD.right), nrow=1)
  colnames(total.result)=c("Est", "Var", "SD", "Left", "Right")
  rownames(total.result)="RD_Total"
  return(total.result=as.data.frame(total.result))
}
```

### Double Regression Estimation of Population Mean $ \bar{Y}$

#### Case 1: When $ \beta $ is a Constant ($ \beta = \beta_0 $, i.e., $ \beta = 1 $)

1. **Estimator for the Population Mean**:
 $$
   \bar{y}_{lrD} = \bar{y} + \beta (\bar{x}' - \bar{x})
   $$

2. **Unbiasedness**:
 $$
   E(\bar{y}_{lrD}(\beta_0)) = \bar{Y} \quad (\text{UE})
   $$

3. **Variance of the Estimator**:
 $$
   \text{Var}(\bar{y}_{lrD}(\beta_0)) = \left( \frac{1}{n'} - \frac{1}{N} \right) S_y^2 + \left( \frac{1}{n} - \frac{1}{n'} \right) \left( S_y^2 + \beta_0^2 S_x^2 - 2\beta_0 S_{yx} \right)
   $$

4. **Estimated Variance of the Estimator**:
 $$
   \widehat{\text{Var}}(\bar{y}_{lrD}(\beta_0)) = \left( \frac{1}{n'} - \frac{1}{N} \right) s_y^2 + \left( \frac{1}{n} - \frac{1}{n'} \right) \left( s_y^2 + {\beta}_0^2 s_x^2 - 2{\beta}_0 s_{yx} \right)
   $$

Here is the Markdown representation of the given mathematical expressions:

---

#### Case II: When $ \beta$ is the regression coefficient of the second-phase sample
$$ \beta = \hat{b} = \frac{S_{yx}}{S_x^2}$$ 

1. **Estimator for the Population Mean**
 $$
   \bar{y}_{lrD} = \bar{y} + \hat{b} (\bar{x}' - \bar{x})
   $$
2. **Asymptotically Unbiased Estimation**
 $$
   E(\bar{y}_{lrD}) \approx \bar{Y} \quad (\text{AUE})
   $$

3. **Variance of the Estimator**
 $$
   \text{Var}(\bar{y}_{lrD}) = \left( \frac{1}{n'} - \frac{1}{N} \right) S_y^2 + \left( \frac{1}{n} - \frac{1}{n'} \right) S_y^2 (1 - \rho^2)
   $$

4. **Estimated Variance of the Estimator**
 $$
   \widehat{\text{Var}}(\bar{y}_{lrD}) = \left( \frac{1}{n'} - \frac{1}{N} \right) s_y^2 + \left( \frac{1}{n} - \frac{1}{n'} \right) s_e^2
   $$
 where:
 $$
   s_e^2 = \frac{n-1}{n-2} \left( s_y^2 - \frac{s_{yx}^2}{s_x^2} \right)
   $$

```r
twophase.regression.mean=function(N=NULL, n.1st, xbar.1st, y.sample, x.sample, alpha, beta0=NULL)
{
  N.inv=ifelse(is.null(N), 0, 1/N)  # Inverse of population size
  n.2nd=length(y.sample)  # Sample size of the second phase

  ybar=mean(y.sample)  # Mean of the study variable
  xbar=mean(x.sample)  # Mean of the auxiliary variable
  sy2 =var(y.sample)  # Variance of the study variable
  sx2 =var(x.sample)  # Variance of the auxiliary variable
  syx =cov(y.sample, x.sample)  # Covariance between study and auxiliary variables          
  if (!is.null(beta0))
{
  ybar.lrD.est = ybar +beta0*(xbar.1st-xbar)  # Linear regression estimator

  ybar.lrD.var1 = (1/n.1st - N.inv)*sy2
  ybar.lrD.var2 = (1/n.2nd - 1/n.1st)*(sy2 + beta0^2*sx2 - 2*beta0*syx)
  ybar.lrD.var = ybar.lrD.var1 + ybar.lrD.var2  # Variance of the linear regression estimator
  ybar.lrD.sd =sqrt(ybar.lrD.var)  # Standard deviation of the linear regression estimator
}
  else
  {
    beta=syx/sx2  # Slope of the linear regression line
    ybar.lrD.est = ybar +beta*(xbar.1st-xbar)  # Linear regression estimator

    se2 = (n.2nd -1)/(n.2nd -2)*(sy2 - (syx/sx2))
    ybar.lrD.var1 = (1/n.1st - N.inv)*sy2
    ybar.lrD.var2 = (1/n.2nd - 1/n.1st)*se2
    ybar.lrD.var = ybar.lrD.var1 + ybar.lrD.var2  # Variance of the linear regression estimator
    ybar.lrD.sd =sqrt(ybar.lrD.var)  # Standard deviation of the linear regression estimator    
  }
  ci.result =conf.interval(ybar.lrD.est, ybar.lrD.sd, alpha)  # Confidence interval for the linear regression estimator
  ybar.lrD.left =ci.result$left  # Left endpoint of the confidence interval
  ybar.lrD.right=ci.result$right  # Right endpoint of the confidence interval
  mean.result = matrix(c(ybar.lrD.est, ybar.lrD.var, ybar.lrD.sd, ybar.lrD.left, ybar.lrD.right), nrow=1)  # Matrix containing the results of the linear regression estimator
  colnames(mean.result)=c("Est", "Var", "SD", "Left", "Right")  # Column names for the matrix
  rownames(mean.result)=c("lrD_Mean")  # Row name for the matrix
  return(mean.result = as.data.frame(mean.result))  # Return the results of the linear regression estimator
}
```

```r
twophase.regression.total = function(N, n.1st, xbar.1st, y.sample, x.sample, alpha, beta0=NULL)
{
  result = twophase.regression.mean(N, n.1st, xbar.1st, y.sample, x.sample, alpha, beta0)
  ybar.lrD.est = result$Est
  ybar.lrD.var = result$Var
  ybar.lrD.left = result$Left
  ybar.lrD.right= result$Right


  total.est = N*ybar.lrD.est
  total.var = N^2*ybar.lrD.var
  total.sd = sqrt(total.var)
  total.left = N*ybar.lrD.left
  total.right= N*ybar.lrD.right


  total.result = matrix(c(total.est, total.var, total.sd, total.left, total.right), nrow=1)
  #print(total.result)
  #return(total.result)
  colnames(total.result)=c("Est", "Var", "SD", "Left", "Right")
  rownames(total.result)="lrD_Total"
  return(total.lrD.result = as.data.frame(total.result))
}
```

## Examples
### 7.1

```r
## Example 1: Example 7.1  ######################################
source("Code/ci.r")
source("Code/twophase stra.r")

########## Input data  #########################################
N=8000
nh.1st=c(540, 320, 100, 40)
nh.2nd=c(80, 60, 40, 20)
ybarh=c(2, 7, 15, 40)
s2h=c(1.01, 2.71, 15.38, 690.53)
alpha=0.05

######### data analysis  #######################################################
mean.stD.result=twophase.stra.mean1(N, nh.1st, nh.2nd, ybarh, s2h, alpha)
print(mean.stD.result)

total.stD.result=twophase.stra.total1(N, nh.1st, nh.2nd, ybarh, s2h, alpha)
print(total.stD.result)
```

### 7.2
```r
## Example 2: Example 7.2  ######################################
source("Code/ci.r")
source("Code/twophase ratio.r")
source("Code/twophase regression.r")
########## Input data  #########################################
N=200
n.1st=80
xbar.1st=1080

mydata=read.csv("Data/pig.csv")
print(mydata)
n.2nd=nrow(mydata)

y.sample  =mydata$y
x.sample  =mydata$x

alpha=0.05

######### data analysis  #######################################################
mean.RD.result=twophase.ratio.mean(N, n.1st, xbar.1st, y.sample, x.sample, alpha)
print(mean.RD.result)

total.RD.result=twophase.ratio.total(N, n.1st, xbar.1st, y.sample, x.sample, alpha)
print(total.RD.result)

mean.lrD.result=twophase.regression.mean(N, n.1st, xbar.1st, y.sample, x.sample, alpha,beta0 = NULL)
print(mean.lrD.result)

total.lrD.result=twophase.regression.total(N, n.1st, xbar.1st, y.sample, x.sample, alpha,beta0=NULL)
print(total.lrD.result)
```

# Chapter 8 Cluster Sampling
## Functions
### Estimation of the unit mean $\overline{\overline{Y} }$
1. **Estimation**
 $$
   \overline{\overline{y}} = \frac{1}{nM} \sum_{i=1}^n \sum_{j=1}^M y_{ij} = \left( \frac{1}{M} \right) \bar{y}
   $$
 $$
   \left( = \frac{1}{n} \sum_{i=1}^n \bar{y}_i = \text{mean}(\bar{y}_1, \ldots, \bar{y}_n) \right)
   $$

2. **Unbiased**
 $$
   E(\overline{\overline{y}}) = \overline{\overline{Y}} \quad (\text{UE})
   $$

3. **Variance of Estimation**
 $$
   \text{Var}(\overline{\overline{y}}) = \frac{1-f}{nM} S_b^2
   $$

4. **Estimation of Variance**
 $$
   \widehat{\text{Var}}(\overline{\overline{y}}) = \frac{1-f}{nM} S_b^2 
   $$

```r
cluster.srs.mean = function(N=NULL, M.ith, ybar.ith, s2.ith, alpha)
{
    n = length(ybar.ith)
    f = ifelse(is.null(N),0,n/N)
    nf = (1-f)/n

    M = ifelse(length(M.ith) == 1, M.ith, mean(M.ith))

    s2.between = M * var(ybar.ith)
    s2.within = mean(s2.ith)

    if(is.null(N))
    {
        w.between = 1/M
        w.within = (M-1)/M

        s2.total = w.between * s2.between + w.within * s2.within
        rho.est = (s2.between - s2.within)/(s2.between + (M-1)*s2.within)

        deff = 1+ (M-1)*rho.est
    }
    else
    {
        w.between = (N-1)/(N*M -1)
        w.within = N*(M-1)/(N*M -1)

        s2.total = w.between * s2.between + w.within * s2.within
        rho.est = (s2.between - s2.within)/(s2.between + (M-1)*s2.within)

        deff = (N*M-1)/(M*(N-1))*(1+(M-1)*rho.est)
    }
    ybar.cluster.est = mean(ybar.ith)
    ybar.cluster.var = (nf/M) * s2.between
    ybar.cluster.sd = sqrt(ybar.cluster.var)
    ci.result = conf.interval(ybar.cluster.est, ybar.cluster.sd, alpha)
    ybar.cluster.left = ci.result$left
    ybar.cluster.right = ci.result$right

    var.result = matrix(c(s2.total, s2.within, s2.between), nrow = 1)
    colnames (var.result) = c("Total", "s2.within","s2.between")
    rownames(var.result) = c("cluster_var")
    deff.result = matrix(c(rho.est,deff),nrow = 1)
    colnames(deff.result) = c("corr","deff")
    rownames(deff.result) = c("cluster_deff")
    ybar.cluster.result = matrix(c(ybar.cluster.est, ybar.cluster.var, ybar.cluster.sd, ybar.cluster.left, ybar.cluster.right), nrow = 1)
    colnames(ybar.cluster.result) = c("Est", "Var", "SD", "Left", "Right")
    rownames(ybar.cluster.result) = c("mean cluster")

    return(list(var.result = as.data.frame(var.result), deff.result = as.data.frame(deff.result), ybar.cluster.result = as.data.frame(ybar.cluster.result)))

}
```

## Examples
### 8.1 & 8.2

```r
## Example 1: Examples 8.1 and 8.2######################################
source("Code/ci.r")
source("Code/cluster mean.r")

########## Input data  #########################################
N=512
M.ith=8

ybar.ith=c(188, 180.5, 149.75, 207.875, 244.25, 278.5, 182.75, 211.5, 253.125, 191.125, 274.75, 258.375)
s2.ith=c(27.19, 17.98, 17.32, 29.17, 45.2, 63.87, 38.77, 27.48, 44.52, 28.29, 43.7, 43.52)^2

alpha=0.05

######### data analysis  #######################################################
mean.cluster.result=cluster.srs.mean(N, M.ith, ybar.ith, s2.ith, alpha)
var.result         =mean.cluster.result$var.result
deff.result        =mean.cluster.result$deff.result
ybar.cluster.result=mean.cluster.result$ybar.cluster.result

print(var.result)
print(deff.result)
print(ybar.cluster.result)
```

