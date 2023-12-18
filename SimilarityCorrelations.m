%% Calculate similarity correlations between task runs

homedir = '{/path/homedir}'
cd (homedir)

%%load text files 
files = dir('*.txt')

    
    for t = 1:3  %%for task runs 1:3
        
        for c = 11:16  %%for conditions 11-16 from FSL First Level Contrast Conditions
            
            for f = 1:length(files)
        
                
                path = strcat('/Path/To/TextFiles',num2str(t),'/Cope',num2str(c))
                cd (path)
        
    
                a = load(files(f).name);
                voxels(:,c-10,t,f) = a(4,:)'; %%voxel x cope x task x subject matrix
                
            end
        end
    end
    
    %%extract voxel x cope x task for EACH subject
    c1 = [1 1 2 2 3 3]  %%6 pairs of possible task run combinations
    c2 = [2 3 3 1 2 1] 
    
    for f = 1:21
             
        %%calculate correlation matrix across the three tasks for single
        %%subject
        matrix = voxels(:,:,:,f); %% voxel x cope x task 
        
        for c = 1:length(c1)
            one = matrix(:,:,c1(c));
            two = matrix(:,:,c2(c));
             
                for col = 1:6
                    for row = 1:6
                    final(row,col,c)=corr(one(:,row),two(:,col));
                    end
                end
                
        end
        
        
        for d = 1:3   %%remove duplicates along diagonal for 3 of 6 comparisons to account for overlap
             y = final(:,:,d);    
             y(logical(eye(size(y))))=NaN ;  
             final(:,:,d) = y;
        end
                   
    %%average across tasks for each subject then put into final matrix
    
    finalsubjavg(:,:,f)=nanmean(final,3);  %%final matrix is a condition(1) x condition(2) correlation matrix for all subjects(3)
            
          
    end            
         
         
            
     mean(finalsubjavg,3)
     
     
     %%conduct ttests across conditions
     %%row 1
     
     onerow=4
     onecol=4
     tworow=5
     twocol=5
     
    
            xx = squeeze(finalsubjavg(onerow,onecol,1:21));
            yy = squeeze(finalsubjavg(tworow,twocol,1:21));
            [h,p] = ttest(xx,yy)
          

            
%% Plot 
     
measures = horzcat(xx,yy);
nCats = 2;
nDatas = 21;

figure();
boxplot(measures(1:nDatas, 1:nCats), 'Symbol', 'k.'); hold on;
line(repmat([(1:nCats).';NaN], [nDatas,1]), ...
  reshape(measures(1:nDatas,[1:nCats, 1]).', [], 1), ...
  'Color', 0.7*[1 1 1], 'Marker', '.', 'MarkerSize', 10);

ylim([-.2 0.8])


     
           
        
        
        
    
    

    
    