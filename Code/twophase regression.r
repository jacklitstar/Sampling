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




twophase.regression.total = function(N=NULL, n.1st, xbar.1st, y.sample, x.sample, alpha, beta0=NULL)
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