

//IP Address

//#define IPAdress @"192.168.43.199"
#define IPAdress @"192.168.43.1"

//指令格式
#define COMMAND @"http://%@:8080/puze?cmd="
//
//ID对照表
//typeList
//@"http://192.168.43.1:8080/puze?cmd=0x01&filename=typelist.txt"

//下载歌单
//http://192.168.43.1:8080/puze?cmd=0x01&filename=songlist.txt

//歌星列表
//http://192.168.43.1:8080/puze?cmd=0x01&filename=singlist.txt

//歌星图片
//
//http://192.168.43.1:8080/puze?cmd=0x02&filename=歌星名


//
//服务
//http://192.168.43.1:8080/puze?cmd=0xb1
//
//气氛
//http://192.168.43.1:8080/puze?cmd=0xb2&ID= (1,喝彩 2，倒彩 3，明亮 4，柔和 5 动感 6 开关)
//祝福（文字）
//http://192.168.43.1:8080/puze?cmd=0xb3&label=文字
//祝福（图片）(最大512*512)
//http://192.168.43.1:8080/puze?cmd=0xb4
//（数据流）
//调音
//http://192.168.43.1:8080/puze?cmd=0xb5&ID=(1麦克风 2 音乐 3 功放 4音调 ) &vol=音量
//
//静音/放音
//http://192.168.43.1:8080/puze?cmd=0xb6&ID=(1静音 2=放音)
//
//音量(-+)
//http://192.168.43.1:8080/puze?cmd=0xb7&vol=音量
//
//切歌
//http://192.168.43.1:8080/puze?cmd=0xb8
//
//
//重唱
//http://192.168.43.1:8080/puze?cmd=0xb9

//暂停/播放
//http://192.168.43.1:8080/puze?cmd=0xba&ID=(1暂停 2 播放)
//
//原唱/伴唱
//http://192.168.43.1:8080/puze?cmd=0xbb&ID=(1原唱2伴唱)


//取已点歌单
//http://192.168.43.1:8080/puze?cmd=0xbc


//删除已点
//http://192.168.43.1:8080/puze?cmd=0xbd&orderid=序号

//已点移到顶
//http://192.168.43.1:8080/puze?cmd=0xbe&orderid=序号
//
//已点打乱
//http://192.168.43.1:8080/puze?cmd=0xbf
//
//已点还原
//http://192.168.43.1:8080/puze?cmd=0xc0

//点歌
//http://192.168.43.1:8080/puze?cmd=0xc1&number=编号
//
//点歌(顶)
//http://192.168.43.1:8080/puze?cmd=0xc2&number=编号

//推送视频(音频)
//http://192.168.43.1:8080/puze?cmd=0xe1
//（数据流）
//
//推送图片
//http://192.168.43.1:8080/puze?cmd=0xe2
//(数据流）

 
// 重开
// http://192.168.43.1:8080/puze?cmd=0xd1
// 
// 关机
//#define SHUTDOWN @"http://192.168.43.1:8080/puze?cmd=0xd2"

#define SAVAPATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject]

#import <Foundation/Foundation.h>
#import "AFNetworking.h"


@interface DownLoadOperation : NSObject

@property(nonatomic , strong) NSURL* url;
@property(nonatomic , copy) NSString* (^cachePath)(void);
@property(nonatomic , strong) AFHTTPRequestOperation* requestOperation;
@property(nonatomic , copy) void(^progressBlock)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead);

//downloadFiles
-(void)downloadWithUrl:(id)url
             cachePath:(NSString* (^) (void))cacheBlock
         progressBlock:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))progressBlock
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


//下载文件

-(void)downloadFileWithFileName:(NSString*)fileName
             cachePath:(NSString* (^) (void))cacheBlock
         progressBlock:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))progressBlock
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//歌星图片
- (void)downLoadPicturesWithSinger:(NSString*)singer
            CachePath:(NSString* (^) (void))cacheBlock
           progressBlock:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))progressBlock
                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)sendCmd_FUWU;//服务
//气氛(1,喝彩 2，倒彩 3，明亮 4，柔和 5 动感 6 开关)
- (void)sendCmd_qiFen:(int)value;
//祝福文字
- (void)sendCmd_zhuFuWithWord:(NSString*)value;
//祝福（图片）(最大512*512)数据流
- (void)sendCmd_zhuFuWithPicture:(NSData*)data;
//静音/放音
- (void)sendCmd_soundStopPlay:(BOOL)value;
//音量(-+)
- (void)sendCmd_soundAdjust:(int)value;
//调音(1麦克风 2 音乐 3 功放 4音调 ) & value
- (void)sendCmd_yingDiaoAdjustToObject:(int)who value:(int)value;
//切歌
- (void)sendCmd_switchSong;
//重唱
- (void)sendCmd_rePlay;
//暂停/播放
- (void)sendCmd_stopPlay:(BOOL)value;
//原唱/伴唱
- (void)sendCmd_yuanChang_pangChang:(BOOL)value;
 //获取已点歌单
- (void)sendCmd_get_yiDianList;
//删除已点
- (void)sendCmd_remove_yidian;
//已点打乱
- (void)sendCmd_yiDianDaluang;
//已点移到顶
- (void)sendCmd_moveSongToTop;
//已点还原
- (void)sendCmd_yiDianResume;
//点歌
- (void)sendCmd_Diange:(NSString*)number;
//点歌(顶)
- (void)sendCmd_DiangeToTop:(NSString*)number;
//推送视频(音频)
- (void)sendCmd_pushVideoAudio;
//推送图片
- (void)sendCmd_pushPicture;
// 重开
- (void)sendCmd_restartDevice;
// 关机
- (void)sendCmd_shutdownDevice;

@end
