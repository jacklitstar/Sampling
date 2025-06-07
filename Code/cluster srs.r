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