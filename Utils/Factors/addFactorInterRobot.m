function R=addFactorInterRobot(R,factorR,labelRobot)

if (ismember(factorR(2),R.idX))
    if(ismember(factorR(1),R.idX))
        % add other factorRs
        [R.A, R.b]=addfactor(factorR,R.config,R.A,R.b,R.ndxR,R.dim);
        R.F=[R.F;factorR];
        R.ndxR=R.ndxR+R.dim;
        R.FLabel=[R.FLabel; labelRobot]; %DEBUG ONLY
    else
        % we add an odometric link!!
        % add odo factorR
        odo=factorR(3:5);
        % Add pose to config
        R.config=addPose(odo,R.dim,R.config);
        % Add factorR to matrix
        [R.A,R.b]=addfactor(factorR,R.config,R.A,R.b,R.ndxR,R.dim);
        % Add factorR to the system (X,F)
        % Here we have to take care of the indexes
        % factorR(1)- the new factorR to be added
        R.ndxR=R.ndxR+R.dim;
        R.idX= [R.idX;factorR(1)];
        R.F=[R.F;factorR];
        R.FLabel=[R.FLabel; labelRobot]; %DEBUG ONLY
    end
end


end