%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     Black Box Fast Multipole Method
%             Written for C++ by    : Sivaram Ambikasaran, Ruoxi Wang
%             Written for Matlab by : Fahd Siddiqui and Ali Rezaei                             
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function assign_Children( Tree, node, R, nChebNodes,cNode,TNode )
% Assigns Children to the given node

if node.N == 0
    node.isLeaf	 =	true;
    node.isEmpty =	true;
    
else
    node.potential     = zeros(node.N , Tree.m);
    node.nodePotential = zeros(Tree.rank , Tree.m);
    node.nodeCharge    = zeros(Tree.rank , Tree.m);
    node.isEmpty       = false;
    node.isLeaf        = false;
    
    H2_2D_Tree.get_Scaled_ChebNode(node , cNode);
    
    for k = 1 : node.N
        
        node.location(k , :) = Tree.locationTree(node.index(k) , :);
        
    end
    
    % Operation on leaf cell ---------------------------------------------------
    if node.N <= 4*Tree.rank   
        node.isLeaf = true;
        node.R      = H2_2D_Tree.get_Transfer_From_Parent_To_Children(node.N, nChebNodes , node.location , node.center , node.radius , TNode);

        if Tree.maxLevels < node.nLevel
            Tree.maxLevels = node.nLevel;
        end
    else
        for i=1:4 % Initilize each child
            node.child(i , 1) = H2_2D_Node(0 , 0);
        end
        for k = 1 : 4 
            node.child(k).nLevel     = node.nLevel + 1;
            node.child(k).nodeNumber = k;
            node.child(k).parent     = node;
            node.child(k).center(1)  = node.center(1) + (rem(k-1 , 2) - 0.5) * node.radius(1);
            node.child(k).center(2)  = node.center(2) + (double(idivide(int32(k-1) , int32(2))) - 0.5) * node.radius(2);
            node.child(k).radius     = node.radius * 0.5;
            node.child(k).N          = 0;
        end
        
        % Assigning index number from parent to children -----------------------
        for k = 1 : node.N
            if Tree.locationTree(node.index(k) , 1) < node.center(1)
                if Tree.locationTree(node.index(k),2) < node.center(2)
                    node.child(1).index(node.child(1).N + 1) = node.index(k);
                    node.child(1).N = 1 + node.child(1).N;
                else
                    node.child(3).index(node.child(3).N + 1) = node.index(k);
                    node.child(3).N = 1 + node.child(3).N;
                end
            else
                if Tree.locationTree(node.index(k),2) < node.center(2)    
                    node.child(2).index(node.child(2).N + 1) = node.index(k);
                    node.child(2).N = 1 + node.child(2).N;
                else
                    node.child(4).index(node.child(4).N + 1) = node.index(k);
                    node.child(4).N =1+node.child(4).N;
                end
            end
        end
        
        % Calling assign children to each child --------------------------------
        for k=1:4
            H2_2D_Tree.assign_Children(Tree, node.child(k,1) , R , nChebNodes , cNode , TNode );
        end
    end
end