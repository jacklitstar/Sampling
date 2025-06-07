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

