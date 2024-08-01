#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>
#import <Foundation/Foundation.h>
//Imgui library
#import "Esp/CaptainHook.h"
#import "Esp/ImGuiDrawView.h"
#import "IMGUI/imgui.h"
#import "IMGUI/imgui_impl_metal.h"
#import "IMGUI/Honkai.h"
//Patch library
#import "5Toubun/NakanoIchika.h"
#import "5Toubun/NakanoNino.h"
#import "5Toubun/NakanoMiku.h"
#import "5Toubun/NakanoYotsuba.h"
#import "5Toubun/NakanoItsuki.h"
#import "5Toubun/dobby.h"

#define kWidth  [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#define kScale [UIScreen mainScreen].scale

/*
    Components:
 
 - Metal: The code leverages the Metal framework for graphics rendering and GPU acceleration.
 - ImGui: The ImGui library is used to create and manage the graphical elements of the application's user interface.
 - Patch Library: Various patching and hooking functions are employed to modify the behavior of the target application dynamically.
 - Touch Event Handling: The code handles touch events to allow user interactions with the GUI.
 
 Key Features:
 
 - The `MenDeal` boolean variable controls whether the menu is open or closed.
 - The GUI elements are drawn using ImGui, offering features like checkboxes and text display.
 - The code includes patching functions to enable or disable specific in-game cheats based on user interactions with the GUI.
 - It utilizes Metal's rendering capabilities to display the GUI on the screen.
 - Touch events are captured and processed to update the GUI's interaction state
     */
 
@interface ImGuiDrawView () <MTKViewDelegate>
@property (nonatomic, strong) id <MTLDevice> device;
@property (nonatomic, strong) id <MTLCommandQueue> commandQueue;
@end

@implementation ImGuiDrawView

//I usually let the function for hooking in here...
void (*huy)(void *instance);
void _huy(void *instance)
{
huy(instance);
}

static bool MenDeal = true;

- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    _device = MTLCreateSystemDefaultDevice();
    _commandQueue = [_device newCommandQueue];

    if (!self.device) abort();
    IMGUI_CHECKVERSION();
    ImGui::CreateContext();
    ImGuiIO& io = ImGui::GetIO(); (void)io;
    ImGui::StyleColorsDark();
    ImFont* font = io.Fonts->AddFontFromMemoryCompressedTTF((void*)Honkai_compressed_data, Honkai_compressed_size, 45.0f, NULL, io.Fonts->GetGlyphRangesDefault());
    ImGui_ImplMetal_Init(_device);
return self;
}

+ (void)showChange:(BOOL)open
{
    MenDeal = open;
}

- (MTKView *)mtkView
{
    return (MTKView *)self.view;
}

- (void)loadView
{
    CGFloat w = [UIApplication sharedApplication].windows[0].rootViewController.view.frame.size.width;
    CGFloat h = [UIApplication sharedApplication].windows[0].rootViewController.view.frame.size.height;
    self.view = [[MTKView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
}

- (void)viewDidLoad {
 [super viewDidLoad];
    self.mtkView.device = self.device;
    self.mtkView.delegate = self;
    self.mtkView.clearColor = MTLClearColorMake(0, 0, 0, 0);
    self.mtkView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    self.mtkView.clipsToBounds = YES;
}

#pragma mark - Interaction
- (void)updateIOWithTouchEvent:(UIEvent *)event
{
    UITouch *anyTouch = event.allTouches.anyObject;
    CGPoint touchLocation = [anyTouch locationInView:self.view];
    ImGuiIO &io = ImGui::GetIO();
    io.MousePos = ImVec2(touchLocation.x, touchLocation.y);

    BOOL hasActiveTouch = NO;
    for (UITouch *touch in event.allTouches)
    {
        if (touch.phase != UITouchPhaseEnded && touch.phase != UITouchPhaseCancelled)
        {
            hasActiveTouch = YES;
            break;
        }
    }
    io.MouseDown[0] = hasActiveTouch;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self updateIOWithTouchEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self updateIOWithTouchEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self updateIOWithTouchEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self updateIOWithTouchEvent:event];
}

#pragma mark - MTKViewDelegate

- (void)drawInMTKView:(MTKView*)view
{
    //main function
    ImGuiIO& io = ImGui::GetIO();
    io.DisplaySize.x = view.bounds.size.width;
    io.DisplaySize.y = view.bounds.size.height;

    CGFloat framebufferScale = view.window.screen.scale ?: UIScreen.mainScreen.scale;
    io.DisplayFramebufferScale = ImVec2(framebufferScale, framebufferScale);
    io.DeltaTime = 1 / float(view.preferredFramesPerSecond ?: 120);
    
    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
    
    //Define your bool/function in here for local scope... can also use objc class and set a @property in the class if extending the cheat for larger complex tasks
    static bool show_s0 = false;    
    static bool show_s1 = false;    
    static bool show_s2 = false;    
    static bool show_s3 = false;    
    static bool show_s4 = false;    
    static bool show_s5 = false;    
    static bool show_s6 = false;                    
    static bool show_s7 = false;        
    static bool show_s8 = false;      
    static bool show_s9 = false;     
    static bool show_s10 = false;     
    static bool show_s11 = false;     
    static bool show_s12 = false;     

    //Define active function
    static bool show_s0_active = false;
        
    [self.view setUserInteractionEnabled:(MenDeal ? YES : NO)];

        MTLRenderPassDescriptor* renderPassDescriptor = view.currentRenderPassDescriptor;
        if (renderPassDescriptor != nil)
        {
            //imgui setup 
            id <MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
            [renderEncoder pushDebugGroup:@"ImGui Jane"];

            ImGui_ImplMetal_NewFrame(renderPassDescriptor);
            ImGui::NewFrame();
            
            ImFont* font = ImGui::GetFont();
            font->Scale = 15.f / font->FontSize;
            
            CGFloat x = (([UIApplication sharedApplication].windows[0].rootViewController.view.frame.size.width) - 360) / 2;
            CGFloat y = (([UIApplication sharedApplication].windows[0].rootViewController.view.frame.size.height) - 300) / 2;
            
            ImGui::SetNextWindowPos(ImVec2(x, y), ImGuiCond_FirstUseEver);
            ImGui::SetNextWindowSize(ImVec2(100, 80), ImGuiCond_FirstUseEver);
            
            if (MenDeal == true)
            {     
            // IMGUI design from begin to end, entitely inside this condition
                ImGuiStyle &style = ImGui::GetStyle();
                style.WindowRounding = 5.0f;
                style.FrameRounding = 5.0f;
                style.GrabRounding = 5.0f;
                style.PopupRounding = 5.0f;
                style.ScrollbarRounding = 5.0f;
                style.TabRounding = 5.0f;
                style.ChildRounding = 5.0f;
              ImGui::Begin("FxL 29.1 t.me/FxL_cheat", &MenDeal);
                
               
                    
                    ImGui::BeginTabBar("Bar");
                    if (ImGui::BeginTabItem("Visuals"))
                    {
                        ImGui::Text("Visuals");
                        
                        
                        
                        
                        
                        ImGui::EndTabItem();
                    }
                    if (ImGui::BeginTabItem("Aimbot"))
                    {
                        ImGui::Text("Aimbot");
                        
                        
                        ImGui::EndTabItem();
                    }
                    if (ImGui::BeginTabItem("Skins"))
                    {
                        ImGui::Text("Skins");
                        
                        
                        
                        
                        
                        ImGui::EndTabItem();
                    }
                    if (ImGui::BeginTabItem("Server"))
                    {
                        ImGui::Text("Server");
                        ImGui::SameLine();
                        
                        
                        ImGui::EndTabItem();
                    }
                    ImGui::EndTabBar();
                }
              ImGui::End();   
            
            
        ImDrawList* draw_list = ImGui::GetBackgroundDrawList();
        
//START MAIN CHEAT CODE HERE
            // by t.me/pisun651
            -----------------------------------------------------
    //Using the imgui menu bools to trigger our hex byte patching cheat function
    if(show_s0){
        if(show_s0_active == NO){
            vm_unity(ENCRYPTOFFSET("0x517A154"), strtoul(ENCRYPTHEX("0x360080D2"), nullptr, 0));
            vm(ENCRYPTOFFSET("0x10517A154"), strtoul(ENCRYPTHEX("0x360080D2"), nullptr, 0));
            }
        show_s0_active = YES;
    } else {
        if(show_s0_active == YES){
            vm_unity(ENCRYPTOFFSET("0x517A154"), strtoul(ENCRYPTHEX("0xF60302AA"), nullptr, 0));
            vm(ENCRYPTOFFSET("0x10517A154"), strtoul(ENCRYPTHEX("0xF60302AA"), nullptr, 0));
            }
        show_s0_active = NO;
    }
        
    //Hooking a function constructor
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
          //use DobbyHook, same use as MSHookFunction but working on JIT, Dopamine!
          DobbyHook((void *)(getRealOffset(ENCRYPTOFFSET("0x5F145F8"))), (void *)_huy, (void **)&huy);
    });


//END CHEAT LOGIC

            //------------------ call imgui render to draw menu and other 'shaders'
            ImGui::Render();
            ImDrawData* draw_data = ImGui::GetDrawData();
            ImGui_ImplMetal_RenderDrawData(draw_data, commandBuffer, renderEncoder);
          
            [renderEncoder popDebugGroup];
            [renderEncoder endEncoding];

            [commandBuffer presentDrawable:view.currentDrawable];
        }

        [commandBuffer commit];
}

- (void)mtkView:(MTKView*)view drawableSizeWillChange:(CGSize)size
{
    
}

@end

