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



seperate.regression.mean=function(Nh, y.sample, x.sample, stra.index, Xbarh, alpha, method = "Min", beta0 = NULL)
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
    stra.regression=regression.mean(y.hth, x.hth, Nh[h], Xbarh[h], alpha, method, beta0)
    
    # Ensure the correct column names are used
    yh.est[h]  =stra.regression$Est
    yh.var[h]  =stra.regression$Var
    yh.sd[h]   =stra.regression$SD
    
    yh.left[h] = stra.regression$Left
    yh.right[h]= stra.regression$Right
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
  rownames(yRS.result)="Mean_ReS"
  return(list(stra.result=as.data.frame(stra.result), yReS.result=as.data.frame(yRS.result)))
}

seperate.regression.total = function(Nh, y.sample, x.sample, stra.index, Xbarh, alpha, method = "Min", beta0 = NULL)
{
  stra.num = length(Nh)
  
  yh.total.est  = rep(0, stra.num)
  yh.total.var  = rep(0, stra.num)
  yh.total.sd   = rep(0, stra.num)
  yh.total.left = rep(0, stra.num)
  yh.total.right= rep(0, stra.num)

  for (h in 1:stra.num)
  {
    y.hth = y.sample[stra.index == h]
    x.hth = x.sample[stra.index == h]
    
    # Estimate mean using regression
    stra.reg = regression.mean(y.hth, x.hth, Nh[h], Xbarh[h], alpha, method, beta0)
    
    # Compute total from mean: Yhat_h = N_h * ybar_reg.h
    yh.total.est[h]  = Nh[h] * stra.reg$Est
    yh.total.var[h]  = (Nh[h]^2) * stra.reg$Var
    yh.total.sd[h]   = sqrt(yh.total.var[h])
    
    yh.total.left[h]  = Nh[h] * stra.reg$Left
    yh.total.right[h] = Nh[h] * stra.reg$Right
  }

  stra.result = cbind(Nh, yh.total.est, yh.total.var, yh.total.sd, yh.total.left, yh.total.right)
  colnames(stra.result) = c("Nh", "Total_Est", "Var", "SD", "Left", "Right")

  Ytotal.est = sum(yh.total.est)
  Ytotal.var = sum(yh.total.var)
  Ytotal.sd  = sqrt(Ytotal.var)

  Ytotal.ci = conf.interval(Ytotal.est, Ytotal.sd, alpha)
  Ytotal.left = Ytotal.ci$left
  Ytotal.right = Ytotal.ci$right

  Ytotal.result = matrix(c(Ytotal.est, Ytotal.var, Ytotal.sd, Ytotal.left, Ytotal.right), nrow = 1)
  colnames(Ytotal.result) = c("Est", "Var", "SD", "Left", "Right")
  rownames(Ytotal.result) = "Total_ReS"

  return(list(stra.result = as.data.frame(stra.result), YReS.result = as.data.frame(Ytotal.result)))
}


combined.regression.mean = function(Nh, y.sample, x.sample, stra.index, Xbar, alpha, method = "Min", beta0 = NULL)
{
  N = sum(Nh)
  n = length(y.sample)
  f = n / N
  nf = (1 - f) / n
  
  # Compute overall sample means
  ybar = mean(y.sample)
  xbar = mean(x.sample)
  
  # Compute variances and covariance
  sy2 = var(y.sample)
  sx2 = var(x.sample)
  syx = cov(y.sample, x.sample)
  
  if (method == "Min")
  {
    beta = syx / sx2
    ybar.reg.est = ybar + beta * (Xbar - xbar)
    ybar.reg.var = nf * (n - 1)/(n - 2) * (sy2 - syx^2 / sx2)
  }
  
  if (method == "Constant" & !is.null(beta0))
  {
    beta = beta0
    ybar.reg.est = ybar + beta * (Xbar - xbar)
    ybar.reg.var = nf * (sy2 + beta^2 * sx2 - 2 * beta * syx)
  }
  
  ybar.reg.sd = sqrt(ybar.reg.var)
  ci = conf.interval(ybar.reg.est, ybar.reg.sd, alpha)
  
  ybar.reg.result = matrix(c(ybar.reg.est, ybar.reg.var, ybar.reg.sd, ci$left, ci$right), nrow = 1)
  colnames(ybar.reg.result) = c("Est", "Var", "SD", "Left", "Right")
  rownames(ybar.reg.result) = "Mean_Reg_Combined"
  
  # Also return per-stratum means (just simple means, no regression used per stratum)
  Wh = Nh / N
  stra.means = sapply(split(y.sample, stra.index), mean)
  stra.Nh = tapply(y.sample, stra.index, length)
  stra.Wh = stra.Nh / N
  stra.result = cbind(stra.Nh, stra.Wh, stra.means)
  colnames(stra.result) = c("Nh", "Wh", "Sample_Mean")
  
  return(list(stra.result = as.data.frame(stra.result), yRegC.result = as.data.frame(ybar.reg.result)))
}

combined.regression.total = function(Nh, y.sample, x.sample, stra.index, Xbar, alpha, method = "Min", beta0 = NULL)
{
  N = sum(Nh)
  stra.num=length(Nh)
  Wh=Nh/sum(Nh)


  yst.result=stra.srs.mean2(Nh, y.sample, stra.index, alpha)$mean.result
  xst.result=stra.srs.mean2(Nh, x.sample, stra.index, alpha)$mean.result
  # Get combined regression mean estimate
  Yst = N * yst.result$mean.est
  Xst = N * xst.result$mean.est

  nh  =rep(0, stra.num)
  sy2 =rep(0, stra.num)
  sx2 =rep(0, stra.num)
  syx =rep(0, stra.num)
  variance =rep(0, stra.num)
  upp =rep(0, stra.num)
  low =rep(0, stra.num)

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
  for (h in 1:stra.num)
  {
    upp[h] = Wh[h]^2*(1-fh[h]) * syx[h]/nh[h]
    low[h] = Wh[h]^2*(1 - fh[h]) *sx2[h]/nh[h]
  }
  beta = sum(upp) / sum(low)
  print('beta:')
  print(beta)
  for(h in 1:stra.num)
  {
    variance[h] = Nh[h]^2 * (1 - fh[h]) * (sy2[h] - 2 * beta * syx[h] + beta^2 * sx2[h]) / nh[h]
  }
  ytot.RegC.est = Yst + beta * (N * Xbar - Xst)
 
  # Convert mean estimate to total estimate
  ytot.RegC.var  = sum(variance)
  ytot.RegC.sd   = sqrt(ytot.RegC.var)
  ytot.ci = conf.interval(ytot.RegC.est, ytot.RegC.sd, alpha)
  ytot.RegC.left = ytot.ci$left
  ytot.RegC.right = ytot.ci$right
  
  # Format result
  ytot.RegC.result = matrix(c(ytot.RegC.est, ytot.RegC.var, ytot.RegC.sd, ytot.RegC.left, ytot.RegC.right), nrow = 1)
  colnames(ytot.RegC.result) = c("Est", "Var", "SD", "Left", "Right")
  rownames(ytot.RegC.result) = "TOTAL_REG_COMBINED"
  
  return(list(
    ytot.RegC.result = as.data.frame(ytot.RegC.result)
  ))
}