# check the actual outcome value in the test set
data$age[nrow(data)]

# split training/test data
data0 <- data %>% filter(row_number() == nrow(data))
data <- data %>% filter(row_number() < nrow(data))

# select variables X, Y
y <- data$age
x <- data %>% dplyr::select(-age)
x <- as.matrix(x)
x0 <- data0 %>% dplyr::select(-age)
x0 <- as.matrix(x0)
n <- nrow(x)


# use lasso to estimate mu
out.gnet = glmnet(x,y,nlambda=100,lambda.min.ratio=1e-3)
lambda = min(out.gnet$lambda)
funs = lasso.funs(lambda=lambda)

# run conformal inference
out.conf = conformal.pred(x, y, x0, 
                          alpha=0.1,
                          train.fun=funs$train, 
                          predict.fun=funs$predict, 
                          verb=TRUE)

# print results
paste('The lower bound is', out.conf$lo, 'and the upper bound is', out.conf$up)
out.conf$pred
