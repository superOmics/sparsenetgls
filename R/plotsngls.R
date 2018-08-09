#'The plotsngls() function is designed to provide the line plots
#'of penalized parameter lambda and variance of regression coefficients
#'in gls regression. It also provides the graph structure of the
#'solution to the precision matrix in the penalized path.
#'
#'@import huge parcor
#'
#'@param fitgls It is a returning object of the sparsnetgls() multivariate
#'generalized least squared regression function.
#'
#'@param lineplot It is a logical indicator. When value=TRUE, it will provide
#'line plot. 
#'
#'@param ncol It is a graph parameter representing number of columns in 
#'the lineplot. 
#'
#'@param nrow It is a graph parameter representing number of rows in 
#'the lineplot. 
#'
#'@param structplot It is a logical indicator. When value=TRUE, it will 
#'provide the structure plot of the specified precision matrix from 
#'the series of the sparsenetgls results. 
#'
#'@param ith_lambda It is the number for the specified precision matrix
#'to be used in the structplot. It represents the ordering number in the
#'precision matrix series from sparsenetgls.    
#'
#'@return Return a plot subject for sparsenetgls including the plot of
#'variance vs lambda and graph structure of the precision matrix estimates. 
#'
#'@examples
#'ndox=5;p=3;n=20
#'VARknown <- rWishart(1, df=4, Sigma=matrix(c(1,0,0,0,1,0,0,0,1),
#'nrow=3,ncol=3))
#'normc <- mvrnorm(n=n,mu=rep(0,p),Sigma=VARknown[,,1])
#'Y0=normc
#'##u-beta
#'u <- rep(1,ndox)
#'X <- mvrnorm(n=20,mu=rep(0,ndox),Sigma=Diagonal(ndox,rep(1,ndox)))        
#'X00 <- scale(X,center=TRUE,scale=TRUE)
#'X0 <- cbind(rep(1,n),X00)
#'#Add predictors of simulated CNA
#'abundance1 <- scale(Y0,center=TRUE,scale=TRUE)+as.vector(X00%*%as.matrix(u))
#'Y1 <- scale(abundance1,center=TRUE,scale=TRUE)
#'nodes <- c(1:p); units <- c(1:n)
#'colnames(Y1) <- nodes
#'response <- data.frame(Y1)
#'responsedata <- stack(response)
#'index <- rep(c(1:p),n)
#'responsedata$ind <- sort(index)
#'stunits <- rep(units,p)
#'stXvar <- apply(X0,2,rep,p)
#'colnames(stXvar) <- colnames(X0)
#'workdata <- data.frame(units=stunits,nodes=responsedata$ind,
#'Y=responsedata$values,stXvar)
#'X=stXvar
#'Y=workdata$Y
#'
#'##sparsenetgls()
#'fitgls <- sparsenetgls(responsedata=abundance1,predictdata=X00,
#'nlambda=5,ndist=3,method="glasso")
#'plotsngls(fitgls, ith_lambda=5)
#'@export

plotsngls <- function(fitgls,lineplot=FALSE,nrow,ncol,
structplot=TRUE,ith_lambda=1) {
lambda <- fitgls$lambda
nlambda <- length(lambda)
covBeta <- fitgls$covBeta
beta <- fitgls$beta
ndox <- length(beta[,1])
ndist <- fitgls$power-1

#line-plot
if (lineplot==TRUE){
par(mfrow=c(nrow,ncol))
nq=nrow*ncol

    for ( i in seq_len(nq))
    {j=1
        maxcov <- max(covBeta[i,i,,],na.rm=TRUE)
        mincov <- min(covBeta[i,i,,],na.rm=TRUE)
        grid=(maxcov-mincov)/20
        plot(lambda,covBeta[i,i,j,],main=paste("beta",i-1,sep=""),
        xlab="lambda",ylab="Estimated variance of beta",type="p",
        pch=19,ylim=c( mincov-mincov/100, maxcov+maxcov/100))
        lines(lambda,covBeta[i,i,j,])

    if (i==nq)  legend(lambda[nlambda-1], round(maxcov,4)-j*grid,
        bty="n",lty=1,col=j,paste("d=",j))
    j=j+1
    while (j <=ndist){
        points(lambda,covBeta[i,i,j,],type="p",pch=19,col=j)
        lines(lambda,covBeta[i,i,j,],col=j)
        if (i==nq)  legend(lambda[nlambda-1], round(maxcov,4)-j*grid,
        bty="n",lty=1,col=j,paste("d=",j))
        j=j+1}
    }
}

#graph-structure
if (structplot==TRUE){
PREC_seq <- fitgls$PREC_seq
precdim=dim(fitgls$PREC_seq[[1]])[1]
adj <- convert_to_adj(fitgls$PREC_seq[[ith_lambda]],p=precdim)
huge.plot(adj,graph.name="precision matrix")
}
}