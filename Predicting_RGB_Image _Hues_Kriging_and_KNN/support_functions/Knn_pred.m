function [struct]=Knn_pred(pos,val,POS,k)




mdl=fitcknn(pos,val,'NumNeighbors',k);
[class prob cost]=predict(mdl,POS);
struct.pred=class;
struct.prob=prob;
struct.cost=cost;
end


