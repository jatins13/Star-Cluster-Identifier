function final_Y=predict_values(X,Y)
    Y(Y==-99.9900)=NaN;
    Y(Y==9999.90)=NaN;
    X_train=[];Y_train=[];
    X_test=[];
    for i=1:size(X,1)
        if ~isnan(Y(i))
            X_train=[X_train;X(i,:)];
            Y_train=[Y_train;Y(i)];
        else
             X_test=[X_test;X(i,:)];
        end

    end
    [Z_train,~]=pca(X_train,1);
    [Z_test,~]=pca(X_test,1);
    mdl=fitlm(Z_train,Y_train,'linear');
    predict_Y=predict(mdl,Z_test);
    final_Y=[Y_train ;predict_Y];
end