--[[

    Library Made for https://octohook.xyz/
    Developed by liam#4567
    Modified by tatar0071#0627
    Mobile Optimized Version

]]

-- // Load

local startupArgs = ({...})[1] or {}

if getgenv().library ~= nil then
    getgenv().library:Unload();
end

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local function gs(a)
    return game:GetService(a)
end

-- // Variables
local players, http, runservice, inputservice, tweenService, stats, actionservice = gs('Players'), gs('HttpService'), gs('RunService'), gs('UserInputService'), gs('TweenService'), gs('Stats'), gs('ContextActionService')
local localplayer = players.LocalPlayer
local mobile = inputservice.TouchEnabled and not inputservice.MouseEnabled

local setByConfig = false
local floor, ceil, huge, pi, clamp = math.floor, math.ceil, math.huge, math.pi, math.clamp
local c3new, fromrgb, fromhsv = Color3.new, Color3.fromRGB, Color3.fromHSV
local next, newInstance, newUDim2, newVector2 = next, Instance.new, UDim2.new, Vector2.new
local isexecutorclosure = isexecutorclosure or is_synapse_function or is_sirhurt_closure or iskrnlclosure;
local executor = (
    syn and 'syn' or
    getexecutorname and getexecutorname() or
    'unknown'
)

local library = {
    windows = {};
    indicators = {};
    flags = {};
    options = {};
    connections = {};
    drawings = {};
    instances = {};
    utility = {};
    notifications = {};
    tweens = {};
    theme = {};
    zindexOrder = {
        ['indicator'] = 950;
        ['window'] = 1000;
        ['dropdown'] = 1200;
        ['colorpicker'] = 1100;
        ['watermark'] = 1300;
        ['notification'] = 1400;
        ['cursor'] = 1500;
        ['openbutton'] = 1600;
    },
    stats = {
        ['fps'] = 0;
        ['ping'] = 0;
    };
    images = {
        ['gradientp90'] = 'https://raw.githubusercontent.com/portallol/luna/main/modules/gradient90.png';
        ['gradientp45'] = 'https://raw.githubusercontent.com/portallol/luna/main/modules/gradient45.png';
        ['colorhue'] = 'https://raw.githubusercontent.com/portallol/luna/main/modules/lgbtqshit.png';
        ['colortrans'] = 'https://raw.githubusercontent.com/portallol/luna/main/modules/trans.png';
    };
    numberStrings = {['Zero'] = 0, ['One'] = 1, ['Two'] = 2, ['Three'] = 3, ['Four'] = 4, ['Five'] = 5, ['Six'] = 6, ['Seven'] = 7, ['Eight'] = 8, ['Nine'] = 9};
    signal = loadstring(game:HttpGet('https://raw.githubusercontent.com/Quenty/NevermoreEngine/main/src/signal/src/Shared/Signal.lua'))();
    open = false;
    opening = false;
    hasInit = false;
    cheatname = startupArgs.cheatname or 'octohook';
    gamename = startupArgs.gamename or 'universal';
    fileext = startupArgs.fileext or '.txt';
    mobile = mobile;
}

library.themes = {
    {
        name = 'Default',
        theme = {
            ['Accent']                    = fromrgb(255,135,255);
            ['Background']                = fromrgb(18,18,18);
            ['Border']                    = fromrgb(0,0,0);
            ['Border 1']                  = fromrgb(60,60,60);
            ['Border 2']                  = fromrgb(35,35,35);
            ['Border 3']                  = fromrgb(10,10,10);
            ['Primary Text']              = fromrgb(235,235,235);
            ['Group Background']          = fromrgb(35,35,35);
            ['Selected Tab Background']   = fromrgb(35,35,35);
            ['Unselected Tab Background'] = fromrgb(18,18,18);
            ['Selected Tab Text']         = fromrgb(245,245,245);
            ['Unselected Tab Text']       = fromrgb(145,145,145);
            ['Section Background']        = fromrgb(18,18,18);
            ['Option Text 1']             = fromrgb(245,245,245);
            ['Option Text 2']             = fromrgb(195,195,195);
            ['Option Text 3']             = fromrgb(145,145,145);
            ['Option Border 1']           = fromrgb(50,50,50);
            ['Option Border 2']           = fromrgb(0,0,0);
            ['Option Background']         = fromrgb(35,35,35);
            ["Risky Text"]                = fromrgb(175, 21, 21);
            ["Risky Text Enabled"]        = fromrgb(255, 41, 41);
        }
    },
    {
        name = 'Tokyo Night',
        theme = {
            ['Accent']                    = fromrgb(103,89,179);
            ['Background']                = fromrgb(22,22,31);
            ['Border']                    = fromrgb(0,0,0);
            ['Border 1']                  = fromrgb(50,50,50);
            ['Border 2']                  = fromrgb(24,25,37);
            ['Border 3']                  = fromrgb(10,10,10);
            ['Primary Text']              = fromrgb(235,235,235);
            ['Group Background']          = fromrgb(24,25,37);
            ['Selected Tab Background']   = fromrgb(24,25,37);
            ['Unselected Tab Background'] = fromrgb(22,22,31);
            ['Selected Tab Text']         = fromrgb(245,245,245);
            ['Unselected Tab Text']       = fromrgb(145,145,145);
            ['Section Background']        = fromrgb(22,22,31);
            ['Option Text 1']             = fromrgb(245,245,245);
            ['Option Text 2']             = fromrgb(195,195,195);
            ['Option Text 3']             = fromrgb(145,145,145);
            ['Option Border 1']           = fromrgb(50,50,50);
            ['Option Border 2']           = fromrgb(0,0,0);
            ['Option Background']         = fromrgb(24,25,37);
            ["Risky Text"]                = fromrgb(175, 21, 21);
            ["Risky Text Enabled"]        = fromrgb(255, 41, 41);
        }
    }
}

-- Rest der Themes bleibt gleich...

local utility = library.utility
do
    -- Utility Funktionen bleiben gleich...
end

library.utility = utility

function library:Unload()
    library.unloaded:Fire();
    for _,c in next, self.connections do
        c:Disconnect()
    end
    for obj in next, self.drawings do
        obj:Remove()
    end
    table.clear(self.drawings)
    getgenv().library = nil
end

function library:init()
    if self.hasInit then
        return
    end

    local tooltipObjects = {};

    makefolder(self.cheatname)
    makefolder(self.cheatname..'/assets')
    makefolder(self.cheatname..'/'..self.gamename)
    makefolder(self.cheatname..'/'..self.gamename..'/configs');

    function self:SetTheme(theme)
        for i,v in next, theme do
            self.theme[i] = v;
        end
        self.UpdateThemeColors();
    end

    -- Config Funktionen bleiben gleich...

    for i,v in next, self.images do
        if not isfile(self.cheatname..'/assets/'..i..'.oh') then
            writefile(self.cheatname..'/assets/'..i..'.oh', game:HttpGet(v))
        end
        self.images[i] = readfile(self.cheatname..'/assets/'..i..'.oh');
    end

    -- Cursor nur für PC
    if not self.mobile then
        self.cursor1 = utility:Draw('Triangle', {Filled = true, Color = fromrgb(255,255,255), ZIndex = self.zindexOrder.cursor});
        self.cursor2 = utility:Draw('Triangle', {Filled = true, Color = fromrgb(85,85,85), self.zindexOrder.cursor-1});
    end
    
    local function updateCursor()
        if not self.mobile then
            self.cursor1.Visible = self.open
            self.cursor2.Visible = self.open
            if self.cursor1.Visible then
                local pos = inputservice:GetMouseLocation();
                self.cursor1.PointA = pos;
                self.cursor1.PointB = pos + newVector2(16,5);
                self.cursor1.PointC = pos + newVector2(5,16);
                self.cursor2.PointA = self.cursor1.PointA + newVector2(0, 0)
                self.cursor2.PointB = self.cursor1.PointB + newVector2(1, 1)
                self.cursor2.PointC = self.cursor1.PointC + newVector2(1, 1)
            end
        end
    end

    local screenGui = Instance.new('ScreenGui');
    if syn then syn.protect_gui(screenGui); end
    screenGui.Parent = game:GetService('CoreGui');
    screenGui.Enabled = true;
    utility:Instance('ImageButton', {
        Parent = screenGui,
        Visible = true,
        Modal = true,
        Size = UDim2.new(1,0,1,0),
        ZIndex = 9999999999,
        Transparency = 1;
    })

    -- Open/Close Button für Mobile
    if self.mobile then
        self.openButton = utility:Draw('Square', {
            Size = newUDim2(0, 50, 0, 50);
            Position = newUDim2(1, -60, 1, -60);
            ThemeColor = 'Accent';
            ZIndex = self.zindexOrder.openbutton;
            CornerRadius = 25;
        })

        self.openButtonText = utility:Draw('Text', {
            Position = newUDim2(.5,0,.5,0);
            Text = 'MENU';
            Color = fromrgb(255,255,255);
            Size = 14;
            Font = 3;
            Center = true;
            ZIndex = self.zindexOrder.openbutton + 1;
            Parent = self.openButton;
        })

        utility:Connection(self.openButton.MouseButton1Down, function()
            self:SetOpen(not self.open)
        end)
    end

    utility:Connection(library.unloaded, function()
        screenGui:Destroy()
    end)

    -- Input Handling für PC
    if not self.mobile then
        utility:Connection(inputservice.InputBegan, function(input, gpe)
            if self.hasInit then
                if input.KeyCode == self.toggleKey and not library.opening and not gpe then
                    self:SetOpen(not self.open)
                    task.spawn(function()
                        library.opening = true;
                        task.wait(.15);
                        library.opening = false;
                    end)
                end
                -- Rest des Input Handlings...
            end
        end)
    end

    -- Rest der Input Handling Funktionen...

    function self:SetOpen(bool)
        self.open = bool;
        screenGui.Enabled = bool;

        if self.mobile and self.openButton then
            self.openButton.Visible = not bool
        end

        if bool and library.flags.disablemenumovement then
            actionservice:BindAction(
                'FreezeMovement',
                function()
                    return Enum.ContextActionResult.Sink
                end,
                false,
                unpack(Enum.PlayerActions:GetEnumItems())
            )
        else
            actionservice:UnbindAction('FreezeMovement');
        end

        updateCursor();
        for _,window in next, self.windows do
            window:SetOpen(bool);
        end

        library.CurrentTooltip = nil;
        if tooltipObjects.background then
            tooltipObjects.background.Visible = false
        end
    end

    -- Rest der Funktionen bleiben gleich...

    function self.NewWindow(data)
        -- Mobile optimierte Fenstergröße
        local defaultSize = self.mobile and newUDim2(0, 350, 0, 500) or newUDim2(0, 525, 0, 650)
        local defaultPosition = self.mobile and newUDim2(.5, -175, .5, -250) or newUDim2(0, 250, 0, 150)
        
        local window = {
            title = data.title or '',
            selectedTab = nil;
            tabs = {},
            objects = {},
            colorpicker = {
                objects = {};
                color = c3new(1,0,0);
                trans = 0;
            };
            dropdown = {
                objects = {
                    values = {};
                };
                max = 5;
            }
        };

        table.insert(library.windows, window);

        ----- Create Objects ----
        do
            local size = data.size or defaultSize;
            local position = data.position or defaultPosition;
            local objs = window.objects;
            local z = library.zindexOrder.window;

            objs.background = utility:Draw('Square', {
                Size = size;
                Position = position;
                ThemeColor = 'Background';
                ZIndex = z;
            })

            -- Rest der Objekterstellung...

            -- Drag nur für PC
            if not library.mobile then
                local dragging, mouseStart, objStart;

                utility:Connection(objs.dragdetector.MouseButton1Down, function(pos)
                    dragging = true;
                    mouseStart = newUDim2(0, pos.X, 0, pos.Y);
                    objStart = objs.background.Position;
                end)

                utility:Connection(button1up, function()
                    dragging = false;
                end)

                utility:Connection(mousemove, function(pos)
                    if dragging then
                        if window.open then
                            objs.background.Position = objStart + newUDim2(0, pos.X, 0, pos.Y) - mouseStart;
                        else
                            dragging = false
                        end
                    end
                end)
            end

        end
        -------------------------

        -- Kompaktere Sektionen für Mobile
        function tab:AddSection(text, side, order)
            local section = {
                text = tostring(text);
                side = side == nil and 1 or clamp(side,1,2);
                order = order or #self.sections+1;
                enabled = true;
                objects = {};
                options = {};
            };

            table.insert(self.sections, section);

            --- Create Objects ---
            do
                local objs = section.objects;
                local z = library.zindexOrder.window+15;

                objs.background = utility:Draw('Square', {
                    ThemeColor = 'Section Background';
                    ZIndex = z;
                    Parent = window.objects['columnholder'..(section.side)];
                })

                objs.innerBorder = utility:Draw('Square', {
                    Size = newUDim2(1,2,1,1);
                    Position = newUDim2(0,-1,0,0);
                    ThemeColor = 'Border 3';
                    ZIndex = z-1;
                    Parent = objs.background;
                })

                objs.outerBorder = utility:Draw('Square', {
                    Size = newUDim2(1,2,1,1);
                    Position = newUDim2(0,-1,0,0);
                    ThemeColor = 'Border 1';
                    ZIndex = z-2;
                    Parent = objs.innerBorder;
                })

                objs.topBorder1 = utility:Draw('Square', {
                    Size = newUDim2(.025,1,0,1);
                    Position = newUDim2(0,-1,0,0);
                    ThemeColor = 'Accent';
                    ZIndex = z+1;
                    Parent = objs.background;
                })

                objs.topBorder2 = utility:Draw('Square', {
                    ThemeColor = 'Accent';
                    ZIndex = z+1;
                    Parent = objs.background;
                })

                objs.textlabel = utility:Draw('Text', {
                    Position = newUDim2(.0425,0,0,-7);
                    ThemeColor = 'Primary Text';
                    Size = library.mobile and 12 or 13;
                    Font = 2;
                    ZIndex = z+1;
                    Parent = objs.background;
                })

                objs.optionholder = utility:Draw('Square',{
                    Size = newUDim2(1-.03,0,1,-15);
                    Position = newUDim2(.015,0,0,13);
                    Transparency = 0;
                    ZIndex = z+1;
                    Parent = objs.background;
                })
                
            end
            ----------------------

            -- Kompaktere Optionen für Mobile
            function section:AddToggle(data)
                local toggle = {
                    class = 'toggle';
                    flag = data.flag;
                    text = '';
                    tooltip = '';
                    order = #self.options+1;
                    state = false;
                    risky = false;
                    callback = function() end;
                    enabled = true;
                    options = {};
                    objects = {};
                };

                local blacklist = {'objects'};
                for i,v in next, data do
                    if not table.find(blacklist, i) ~= toggle[i] ~= nil then
                        toggle[i] = v
                    end
                end

                table.insert(self.options, toggle)

                if toggle.flag then
                    library.flags[toggle.flag] = toggle.state;
                    library.options[toggle.flag] = toggle;
                end

                --- Create Objects ---
                do
                    local objs = toggle.objects;
                    local z = library.zindexOrder.window+25;
                    local height = library.mobile and 22 or 17;

                    objs.holder = utility:Draw('Square', {
                        Size = newUDim2(1,0,0,height);
                        Transparency = 0;
                        ZIndex = z+5;
                        Parent = section.objects.optionholder;
                    })

                    objs.background = utility:Draw('Square', {
                        Size = newUDim2(0,library.mobile and 10 or 8,0,library.mobile and 10 or 8);
                        Position = newUDim2(0,2,0,library.mobile and 6 or 4);
                        ThemeColor = 'Option Background';
                        ZIndex = z+3;
                        Parent = objs.holder;
                    })

                    objs.gradient = utility:Draw('Image', {
                        Size = newUDim2(1,0,1,0);
                        Data = library.images.gradientp45;
                        Transparency = .25;
                        ZIndex = z+4;
                        Parent = objs.background;
                    })

                    objs.border1 = utility:Draw('Square', {
                        Size = newUDim2(1,2,1,2);
                        Position = newUDim2(0,-1,0,-1);
                        ThemeColor = 'Option Border 1';
                        ZIndex = z+2;
                        Parent = objs.background;
                    })

                    objs.border2 = utility:Draw('Square', {
                        Size = newUDim2(1,2,1,2);
                        Position = newUDim2(0,-1,0,-1);
                        ThemeColor = 'Option Border 2';
                        ZIndex = z+1;
                        Parent = objs.border1;
                    })

                    objs.text = utility:Draw('Text', {
                        Position = newUDim2(0,library.mobile and 24 or 19,0,library.mobile and 2 or 1);
                        ThemeColor = 'Option Text 3';
                        Size = library.mobile and 12 or 13;
                        Font = 2;
                        ZIndex = z+1;
                        Outline = true;
                        Parent = objs.holder;
                    })

                    utility:Connection(objs.holder.MouseEnter, function()
                        objs.border1.ThemeColor = 'Accent';
                    end)

                    utility:Connection(objs.holder.MouseLeave, function()
                        objs.border1.ThemeColor = toggle.state and 'Accent' or 'Option Border 1';
                    end)

                    utility:Connection(objs.holder.MouseButton1Down, function()
                        toggle:SetState(not toggle.state);
                    end)

                end
                ----------------------

                function toggle:SetState(bool, nocallback)
                    if typeof(bool) == 'boolean' then
                        self.state = bool;
                        if self.flag then
                            library.flags[self.flag] = bool;
                        end

                        self.objects.border1.ThemeColor = bool and 'Accent' or (self.objects.holder.Hover and 'Accent' or 'Option Border 1');
                        self.objects.text.ThemeColor = bool and (self.risky and 'Risky Text Enabled' or 'Option Text 1') or (self.risky and 'Risky Text' or 'Option Text 3');
                        self.objects.background.ThemeColor = bool and 'Accent' or 'Option Background';
                        self.objects.background.ThemeColorOffset = bool and -55 or 0

                        if not nocallback then
                            self.callback(bool);
                        end

                    end
                end

                function toggle:SetText(str)
                    if typeof(str) == 'string' then
                        self.text = str;
                        self.objects.text.Text = str;
                    end
                end

                tooltip(toggle);
                toggle:SetText(toggle.text);
                toggle:SetState(toggle.state, true);
                self:UpdateOptions();
                return toggle
            end

            -- Weitere kompakte Optionen für Mobile...

            return section
        end

        return window
    end

    -- Tooltip
    do
        local z = library.zindexOrder.window + 2000;
        tooltipObjects.background = utility:Draw('Square', {
            ThemeColor = 'Group Background';
            ZIndex = z;
            Visible = false;
        })

        tooltipObjects.border1 = utility:Draw('Square', {
            Size = UDim2.new(1,2,1,2);
            Position = UDim2.new(0,-1,0,-1);
            ThemeColor = 'Border 1';
            ZIndex = z-1;
            Parent = tooltipObjects.background;
        })

        tooltipObjects.border2 = utility:Draw('Square', {
            Size = UDim2.new(1,4,1,4);
            Position = UDim2.new(0,-2,0,-2);
            ThemeColor = 'Border 3';
            ZIndex = z-2;
            Parent = tooltipObjects.background;
        })

        tooltipObjects.text = utility:Draw('Text', {
            Position = UDim2.new(0,3,0,0);
            ThemeColor = 'Primary Text';
            Size = library.mobile and 12 or 13;
            Font = 2;
            ZIndex = z+1;
            Outline = true;
            Parent = tooltipObjects.background;
        })

        tooltipObjects.riskytext = utility:Draw('Text', {
            Position = UDim2.new(0,3,0,0);
            ThemeColor = 'Risky Text Enabled';
            Text = '[RISKY]';
            Size = library.mobile and 12 or 13;
            Font = 2;
            ZIndex = z+1;
            Outline = true;
            Parent = tooltipObjects.background;
        })

    end

    -- Kompakteres Watermark für Mobile
    self.watermark = {
        objects = {};
        text = {
            {self.cheatname, true},
            {("%s"):format(IonHub_User.User), true},
            {self.gamename, true},
            {'0 fps', true},
            {'0ms', true},
        };
        lock = library.mobile and 'Bottom Left' or 'custom';
        position = library.mobile and newUDim2(0,15,1,-32) or newUDim2(0,0,0,0);
        refreshrate = 25;
    }

    function self.watermark:Update()
        self.objects.background.Visible = library.flags.watermark_enabled
        if library.flags.watermark_enabled then
            self.text[4][1] = library.stats.fps..' fps'
            self.text[5][1] = floor(library.stats.ping)..'ms'

            local text = {};
            for _,v in next, self.text do
                if v[2] then
                    table.insert(text, v[1]);
                end
            end

            self.objects.text.Text = table.concat(text,' | ')
            self.objects.background.Size = newUDim2(0, self.objects.text.TextBounds.X + 10, 0, library.mobile and 22 or 17)

            if not library.mobile then
                local size = self.objects.background.Object.Size;
                local screensize = workspace.CurrentCamera.ViewportSize;

                self.position = (
                    self.lock == 'Top Right' and newUDim2(0, screensize.X - size.X - 15, 0, 15) or
                    self.lock == 'Top Left' and newUDim2(0, 15, 0, 15) or
                    self.lock == 'Bottom Right' and newUDim2(0, screensize.X - size.X - 15, 0, screensize.Y - size.Y - 15) or
                    self.lock == 'Bottom Left' and newUDim2(0, 15, 0, screensize.Y - size.Y - 15) or
                    self.lock == 'Top' and newUDim2(0, screensize.X / 2 - size.X / 2, 0, 15) or
                    newUDim2(library.flags.watermark_x / 100, 0, library.flags.watermark_y / 100, 0)
                )
            end

            self.objects.background.Position = self.position
        end
    end

    do
        local objs = self.watermark.objects;
        local z = self.zindexOrder.watermark;
        local height = library.mobile and 22 or 17;
        
        objs.background = utility:Draw('Square', {
            Visible = false;
            Size = newUDim2(0, 200, 0, height);
            Position = self.watermark.position;
            ThemeColor = 'Background';
            ZIndex = z;
        })

        objs.border1 = utility:Draw('Square', {
            Size = newUDim2(1,2,1,2);
            Position = newUDim2(0,-1,0,-1);
            ThemeColor = 'Border 2';
            Parent = objs.background;
            ZIndex = z-1;
        })

        objs.border2 = utility:Draw('Square', {
            Size = newUDim2(1,2,1,2);
            Position = newUDim2(0,-1,0,-1);
            ThemeColor = 'Border 3';
            Parent = objs.border1;
            ZIndex = z-2;
        })
        
        objs.topbar = utility:Draw('Square', {
            Size = newUDim2(1,0,0,1);
            ThemeColor = 'Accent';
            ZIndex = z+1;
            Parent = objs.background;
        })

        objs.text = utility:Draw('Text', {
            Position = newUDim2(.5,0,0,library.mobile and 3 or 2);
            ThemeColor = 'Primary Text';
            Text = 'Watermark Text';
            Size = library.mobile and 12 or 13;
            Font = 2;
            ZIndex = z+1;
            Outline = true;
            Center = true;
            Parent = objs.background;
        })

    end

    local lasttick = tick();
    utility:Connection(runservice.RenderStepped, function(step)
        library.stats.fps = floor(1/step)
        library.stats.ping = stats.Network.ServerStatsItem["Data Ping"]:GetValue()

        if (tick()-lasttick)*1000 > library.watermark.refreshrate then
            lasttick = tick()
            library.watermark:Update()
        end
    end)

    self.keyIndicator = self.NewIndicator({title = 'Keybinds', pos = newUDim2(0,15,0,325), enabled = false});
    
    self:SetTheme(library.theme);
    self:SetOpen(false); -- Start geschlossen
    self.hasInit = true

end

function library:CreateSettingsTab(menu)
    local settingsTab = menu:AddTab('Settings', 999);
    local configSection = settingsTab:AddSection('Config', 2);
    local mainSection = settingsTab:AddSection('Main', 1);

    configSection:AddBox({text = 'Config Name', flag = 'configinput'})
    configSection:AddList({text = 'Config', flag = 'selectedconfig'})

    local function refreshConfigs()
        library.options.selectedconfig:ClearValues();
        for _,v in next, listfiles(self.cheatname..'/'..self.gamename..'/configs') do
            local ext = '.'..v:split('.')[#v:split('.')];
            if ext == self.fileext then
                library.options.selectedconfig:AddValue(v:split('\\')[#v:split('\\')]:sub(1,-#ext-1))
            end
        end
    end

    configSection:AddButton({text = 'Load', confirm = true, callback = function()
        library:LoadConfig(library.flags.selectedconfig);
    end}):AddButton({text = 'Save', confirm = true, callback = function()
        library:SaveConfig(library.flags.selectedconfig);
    end})

    configSection:AddButton({text = 'Create', confirm = true, callback = function()
        if library:GetConfig(library.flags.configinput) then
            library:SendNotification('Config \''..library.flags.configinput..'\' already exists.', 5, c3new(1,0,0));
            return
        end
        writefile(self.cheatname..'/'..self.gamename..'/configs/'..library.flags.configinput.. self.fileext, http:JSONEncode({}));
        refreshConfigs()
    end}):AddButton({text = 'Delete', confirm = true, callback = function()
        if library:GetConfig(library.flags.selectedconfig) then
            delfile(self.cheatname..'/'..self.gamename..'/configs/'..library.flags.selectedconfig.. self.fileext);
            refreshConfigs()
        end
    end})

    refreshConfigs()

    if not self.mobile then
        mainSection:AddBind({text = 'Open / Close', flag = 'togglebind', nomouse = true, noindicator = true, bind = Enum.KeyCode.End, callback = function()
            library:SetOpen(not library.open)
        end});
    end

    mainSection:AddToggle({text = 'Disable Movement If Open', flag = 'disablemenumovement', callback = function(bool)
        if bool and library.open then
            actionservice:BindAction(
                'FreezeMovement',
                function()
                    return Enum.ContextActionResult.Sink
                end,
                false,
                unpack(Enum.PlayerActions:GetEnumItems())
            )
        else
            actionservice:UnbindAction('FreezeMovement');
        end
    end})

    mainSection:AddButton({text = 'Join Discord', flag = 'joindiscord', confirm = true, callback = function()
        local res = syn.request({
            Url = 'http://127.0.0.1:6463/rpc?v=1',
            Method = 'POST',
            Headers = {
                ['Content-Type'] = 'application/json',
                Origin = 'https://discord.com'
            },
            Body = game:GetService('HttpService'):JSONEncode({
                cmd = 'INVITE_BROWSER',
                nonce = game:GetService('HttpService'):GenerateGUID(false),
                args = {code = 'seU6gab'}
            })
        })
        if res.Success then
            library:SendNotification(library.cheatname..' | joined discord', 3);
        end
    end})
    
    mainSection:AddButton({text = 'Copy Discord', flag = 'copydiscord', callback = function()
        setclipboard('discord.gg/seU6gab')
    end})

    mainSection:AddButton({text = 'Rejoin Server', confirm = true, callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId);
    end})

    mainSection:AddButton({text = 'Rejoin Game', confirm = true, callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId);
    end})

    mainSection:AddButton({text = 'Copy Join Script', callback = function()
        setclipboard(([[game:GetService("TeleportService"):TeleportToPlaceInstance(%s, "%s")]]):format(game.PlaceId, game.JobId))
    end})

    mainSection:AddButton({text = 'Copy Game Invite', callback = function()
        setclipboard(([[Roblox.GameLauncher.joinGameInstance(%s, "%s"))]]):format(game.PlaceId, game.JobId))
    end})

    mainSection:AddButton({text = 'Unload', confirm = true, callback = function()
        library:Unload();
    end})

    mainSection:AddSeparator({text = 'Keybinds'});
    mainSection:AddToggle({text = 'Keybind Indicator', flag = 'keybind_indicator', callback = function(bool)
        library.keyIndicator:SetEnabled(bool);
    end})
    mainSection:AddSlider({text = 'Position X', flag = 'keybind_indicator_x', min = 0, max = 100, increment = .1, value = .5, callback = function()
        library.keyIndicator:SetPosition(newUDim2(library.flags.keybind_indicator_x / 100, 0, library.flags.keybind_indicator_y / 100, 0));    
    end});
    mainSection:AddSlider({text = 'Position Y', flag = 'keybind_indicator_y', min = 0, max = 100, increment = .1, value = 35, callback = function()
        library.keyIndicator:SetPosition(newUDim2(library.flags.keybind_indicator_x / 100, 0, library.flags.keybind_indicator_y / 100, 0));    
    end});

    mainSection:AddSeparator({text = 'Watermark'})
    mainSection:AddToggle({text = 'Enabled', flag = 'watermark_enabled'});
    if not self.mobile then
        mainSection:AddList({text = 'Position', flag = 'watermark_pos', selected = 'Custom', values = {'Top', 'Top Left', 'Top Right', 'Bottom Left', 'Bottom Right', 'Custom'}, callback = function(val)
            library.watermark.lock = val;
        end})
        mainSection:AddSlider({text = 'Custom X', flag = 'watermark_x', suffix = '%', min = 0, max = 100, increment = .1});
        mainSection:AddSlider({text = 'Custom Y', flag = 'watermark_y', suffix = '%', min = 0, max = 100, increment = .1});
    end

    local themeStrings = {"Custom"};
    for _,v in next, library.themes do
        table.insert(themeStrings, v.name)
    end
    local themeTab = menu:AddTab('Theme', 990);
    local themeSection = themeTab:AddSection('Theme', 1);
    local setByPreset = false

    themeSection:AddList({text = 'Presets', flag = 'preset_theme', values = themeStrings, callback = function(newTheme)
        if newTheme == "Custom" then return end
        setByPreset = true
        for _,v in next, library.themes do
            if v.name == newTheme then
                for x, d in pairs(library.options) do
                    if v.theme[tostring(x)] ~= nil then
                        d:SetColor(v.theme[tostring(x)])
                    end
                end
                library:SetTheme(v.theme)
                break
            end
        end
        setByPreset = false
    end}):Select('Default');

    for i, v in pairs(library.theme) do
        themeSection:AddColor({text = i, flag = i, color = library.theme[i], callback = function(c3)
            library.theme[i] = c3
            library:SetTheme(library.theme)
            if not setByPreset and not setByConfig then 
                library.options.preset_theme:Select('Custom')
            end
        end});
    end

    return settingsTab;
end

getgenv().library = library
return library
