%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     Black Box Fast Multipole Method
%             Written for C++ by    : Sivaram Ambikasaran, Ruoxi Wang
%             Written for Matlab by : Fahd Siddiqui and Ali Rezaei                             
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [K] = kernel_Cheb_2D(obj, M,xVec,N,yVec)
% Evaluate kernel at Chebyshev nodes

mbym = [];
nbyn = [];

for j= 1 : M
    for i= 1 : M
        mbym = [mbym ; xVec(i , 1) , xVec(j , 2)];
    end
end


for j= 1 : N
    for i= 1 : N
         nbyn = [nbyn ; yVec(i , 1) , yVec(j , 2)];
    end
end
nbyn;
mbym;
 K = obj.kernel_2D(M * M , mbym , N * N , nbyn);

end