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


