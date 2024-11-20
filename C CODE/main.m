clear all
clc
warning('off','all');
warning;
%%

display(' Mini project on FEATURE EXTRACTION - Image Classification and Object detection' );
display(' Submitted by PRAVEEN V');

%%
display('0.Image classification using SVM and Decision Tree');
display('1.Car Detection using SURF');  
display('2.Moon Detection using SURF ');
display('3.SIFT point extraction');
display('4.Face Recognition using 2d pca');
display('5.Dimentionality reduced FACE extraction');
display('6.EXIT');

choice=0;
    choice=input('Enter UR choice:');
    
switch(choice)
    
%%
case 0
[F NF ]=getcardata();
savematformat(F,NF);
svmclassification();
DT(); % Decision Tree
%%
display('For original test data');
%%
case 1
        
        cd 'E:\SVM or Random Forest\IMAGE_CLASSIFICATION\OBJECT DETECTION\CAR DETECTION';
        car_detection 
        cd 'E:\SVM or Random Forest\IMAGE_CLASSIFICATION\CODE'
        main
%%
     case 2
        
        cd 'E:\SVM or Random Forest\IMAGE_CLASSIFICATION\OBJECT DETECTION\MOON DETECTION';
        moon_detection 
        cd 'E:\SVM or Random Forest\IMAGE_CLASSIFICATION\CODE'
        main
%%  
       case 3
        
        cd 'E:\SVM or Random Forest\IMAGE_CLASSIFICATION\SIFT FEATURE EXTRACTION ';
        sift_points_car
        cd 'E:\SVM or Random Forest\IMAGE_CLASSIFICATION\CODE'
        main
%%  
%%
       case 4
        
        cd 'E:\SVM or Random Forest\IMAGE_CLASSIFICATION\FACE RECOGNITION ';
        face_recognition
        cd 'E:\SVM or Random Forest\IMAGE_CLASSIFICATION\CODE'
        main
        
%%
       case 5
        
        cd 'E:\SVM or Random Forest\IMAGE_CLASSIFICATION\FACE RECOGNITION ';
        img_reconst_2dpca
        cd 'E:\SVM or Random Forest\IMAGE_CLASSIFICATION\CODE'
        main
%%
    case 6
%         exit
          quit
          
otherwise
            display('wrong choice');
            getback=input('Press any KEY to go back to main MENU');
            main();
end

display(' THANK YOU');