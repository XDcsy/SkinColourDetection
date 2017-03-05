# SkinColourDetection
一个简单的肤色区域检测器。A simple skin detection tool using color information.<br>
程序中基于Bayes决策下的SPM模型是根据[此文献](http://cdmd.cnki.com.cn/Article/CDMD-10611-2009224822.htm)中2.4.3节“颜色建模方法-直方图法”设计的。<br>
The SPM module using Bayes classifier is designed refering to the 2.4.3 chapter of [this paper](http://cdmd.cnki.com.cn/Article/CDMD-10611-2009224822.htm).<br>
+ **train.m**<br>
**input:** `*_skin.tif` `*_nonskin.tif`<br>
**output:** `SPM.mat`<br>
**description:**<br>从训练用的图片中手动选取出皮肤与非皮肤区域，其它区域擦成透明，分别保存为`*_skin.tif`和`*_nonskin.tif`。使用tif格式是因为tif格式被matlab读取后，`img(:,:,4)`即表示透明通道，方便程序判断被选取出的区域。<br>
在处理时256量化级数的RGB图像被转换为32量化级数，这是因为有[文献](https://link.springer.com/article/10.1023/A:1013200319198)中指出量化级数为32的模型具有最优的肤色检测综合性能。<br>
Manually pick up the skin and nonskin spaces in the training images and set the other spaces transparent. Save them as `*_skin.tif` and `*_nonskin.tif`. I'm using .tif format because then in matlab, `img(:,:,4)` represents the Alpha Channel so that it's easy for the program to recogonize the picked spaces.<br>
While processing, the quantization level of the images is transformed from 256 to 32. It is because [a paper](https://link.springer.com/article/10.1023/A:1013200319198) points out that using images with 32 quantization levels leads to the best comprehensive  efficiency.<br>
+ **test.m**<br>
**input:** `SPM.mat` `*.jpg`<br>
**output:** `*.jpg`<br>
**description:**<br>
通过SPM对测试图像进行检测，输出对应的二值图像：检测为皮肤的部分标为纯白、其它部分标为纯黑。<br>
Use SPM to detect the images and output binary images. The skin pixels are marked with pure white and nonskin pixels with pure black.
