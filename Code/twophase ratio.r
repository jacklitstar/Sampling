# Function to estimate the mean using a two-phase ratio estimator
# N: Population size (optional)
# n.1st: Sample size of the first phase
# xbar.1st: Mean of auxiliary variable from the first phase
# y.sample: Sample of the study variable from the second phase
# x.sample: Sample of the auxiliary variable from the second phase
# alpha: Significance level for confidence interval

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

# Function to estimate the total using a two-phase ratio estimator
# N: Population size
# n.1st: Sample size of the first phase
# xbar.1st: Mean of auxiliary variable from the first phase
# y.sample: Sample of the study variable from the second phase
# x.sample: Sample of the auxiliary variable from the second phase
# alpha: Significance level for confidence interval

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