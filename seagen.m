function seagen()
    T=4;
    N=50000;
    temp=ceil(T/4);
      theta = [7*ones(1,temp),9*ones(1,temp),...
          8*ones(1,temp),9.5*ones(1,temp)];
      theta = [theta,theta];
      noise = 0.1;
     
      for t = 1:T
        [xTrain{t},cTrain{t}] = SEA(theta(t),N,noise);
        [xTest{t},cTest{t}] = SEA(theta(t),N,noise);
%         store(t)=sum(cTrain{t}==2);
%         if(mod(t,1)==0)
%             plot(store);
%             drawnow
%         end
      end
      
      for t=1:4
      d_store{t}=getdstore(xTrain{t},cTrain{t},xTest{t},cTest{t});
      end
save('seaagenbig.mat','d_store');
end
function [X,Y] = SEA(theta,N,noise)
  Nnoise = floor(N*noise);
  %%%% generate data and labels associated with each instance
  x = 10*rand(3,N);
  X = x; % save data in X
  Y = zeros(1,length(X));
  x(3,:) = []; % remove feature w/ no information
  Y(sum(x)>=theta) = 1;
  Y(Y~=1) = 2;
  %%%% add noise into the dataset
  r = randperm(numel(Y));
  r(Nnoise+1:numel(Y)) = [];
  Y(r) = Y(r)-1; % change 2->1 and 1->0
  Y(Y==0) = 2;   % class '0' is actually class '2' with noise
end

function d_store=getdstore(x,t,test_x,test_t)
[x,t]=fix(x,t);
total=size(x,2);
numtrain=ceil(total*.7);
tr_x=x(:,1:numtrain);
tr_t=t(:,1:numtrain);
val_x=x(:,numtrain+1:end);
val_t=t(:,numtrain+1:end);

[test_x,test_t]=fix(test_x,test_t);
d_store.x=tr_x;
d_store.t=tr_t;
d_store.val_x=val_x;
d_store.val_t=val_t;
d_store.test_x=test_x;
d_store.test_t=test_t;
d_store.accsvm=1;
d_store.accnet=1;

end

function [x,t]=fix(x,t)
ids=randperm(size(x,2));
x=double(x(:,ids));
t=t(:,ids);

minx=min(x');


for i=1:size(x,1)
    x(i,:)=x(i,:)-minx(i);
    maxx=max(x(i,:));
    x(i,:)=x(i,:)./maxx;
    x(i,:)=(x(i,:)./0.5)-1;
end
t=full(ind2vec(t));

end