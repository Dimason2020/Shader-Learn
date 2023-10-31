using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public static class TextsLibrary
{
    private static string _newLine = Environment.NewLine;
    private static string _newLineTwice = Environment.NewLine + Environment.NewLine;

    public static readonly string LIGHT_MODE = $"Lambert - основний режим, підтримує 1 направлене джерело світла (з тінью) та лайтмап {_newLineTwice} Unlit - без освітлення, але підтримує блік, найшвидший режим {_newLineTwice} Soft Lambert - Lambert з мʼяким освітленням, цікаво працює на округлих формах, таких як сфери чи стікмен {_newLineTwice} Baked Only - тільки лайтмап та відблиск, для сцен з запіченим світлом (RIP Blob Escape 2021-2023)";
    public static readonly string _Color = $"Також впливає на текстуру альбедо (якщо є)";
    public static readonly string USE_GRADIENT = $"Fresnel - перламутровий {_newLineTwice} World - градієнт у світових координатах {_newLineTwice} Object - градієнт у локальних координатах моделі, працює повільніше, за можливістю використовуйте World";
    public static readonly string _Color2 = $"";
    public static readonly string _GradientSettings = $"[X] Старт [Y] Кінець";
    public static readonly string _UseTexture = $"";
    public static readonly string UV_MODE = $"Model UV - звичайна розгортка яку роблять наші ахуєнні 3д артісти, благослови їх Господь!!! {_newLineTwice} Object Space - швидко працює для прямих кубічних обʼєктів, розгортає за координадами моделі {_newLineTwice} Wall та Floor використовувалися для стін, підлоги і стелі у Blob Escape. Я сам погано памʼятаю у чому прикол, гляну якщо будемо робити ще якийсь проект з інтерʼєрами";
    public static readonly string _MainTex = $"[Albedo] базовий колір";
    public static readonly string _AlbedoAlphaIsOcclusion = $"[Ambient Occlusion] Карта затемнення, якщо є, має бути записана в альфу альбедо";
    public static readonly string _UseNormalMap = $"";
    public static readonly string _NormalMap = $"";
    public static readonly string _NormalFlipY = $"DirectX і OpenGL по-різному рахують напрям Y (зелений канал). В інтернеті є і ті і ті ассети. В ідеалі потрібно перевертати зелений канал у нормалмапі так щоби випуклості були ніби підсвічені зеленим знизу, а ця функція була вимкнена. Але це не критично, для швидкого тесту можете користуватись";
    public static readonly string _NorBlueIsNonmetallic = $"У фіналі мапа неметалевості (чорний для металу, білий для пластику/каменю) має зберігатись у синьому каналі нормалмапи. Нормалмапа від цього не постраждає, вона відтвориться у шейдері з червоного на зеленого";
    public static readonly string _NorAlphaIsRoughness = $"Roughness (або 1 - Smoothness) має бути записана в альфа канал нормалмапи. Чорний для ідеально гладкої поверхні, білий для шорсткої (дифузної)";
    public static readonly string _UseGlow = $"Працює як Fresnel. Використовується переважно щоб імітувати відбиття світла від оточення позаду обʼєкта. Також може використовуватись як градієнт що не затемнюється тінню, або як емісія якщо викрутити тонкість в 0";
    public static readonly string _GlowColor = $"";
    public static readonly string _GlowPower = $"";
    public static readonly string _UseSpecular = $"[Specular] Відблиск від направленого джерела світла";
    public static readonly string _SpecularMultiplier = "Також впливає на текстуру альбедо (якщо є)";
    public static readonly string USE_CUBEMAP = $"Панорамна текстура для імітаціі відбиття {_newLineTwice} Global - бере скайбокс з налаштувань сцени Rendering > Lighting > Environment > Environment Refleclions, намагайтесь використовувати цей варіант {_newLineTwice} Local - можливість задати окремий кубмап саме для цього матеріалу";
    public static readonly string _Cubemap = $"Texture Shape у налаштуваннях текстури має бути Cube. Для плавного переходу між рівнями розмиття використовуйте Trilinear фільтрацію (повільніше ніж Bilinear)";
    public static readonly string _CubemapColor = $"[Specular color] Тут задається колір металу";
    public static readonly string _CubemapPower = $"[Metallic] 0 для металу, пластик у межах 1-2, більші значення для реалістичних матеріалів";
    public static readonly string _Roughness = $"[Roughness/Smoothness] Впливає на розмиття відблиску та відбиття. Якщо використовуєте підсвічування для імітаціі відбиття - намагайтесь тримати їх розмиття і яскравість на одному рівні";
    public static readonly string _UniversalHD = $"Покращує якість різкого відблиску на округлих обʼєктах, жере трохи більше. Використовуйте для обʼєктів що близько до камери або за потреби";
    public static readonly string _OutlineScale = $"";
    public static readonly string _OutlineColor = $"";
    public static readonly string _UseEmissionTex = $"";
    public static readonly string _EmissionTex = $"";
    public static readonly string _EmissionMultiplier = $"";
    public static readonly string _UseCC = $"Запатентована AI Machine Deepthroat технологія FLEXUS™ COLOR CORRECTION® з трьох строчок коду і двох багів. Збільшує контраст та намагається зробити тінь кольоровою замість звичайного затемнення (чим темніше альбедо тим сильніший цей еффект)";
    public static readonly string _Saturation = $"";
    public static readonly string _Brightness = $"";
    public static readonly string _TestTextures = $"";
    public static readonly string _RoughnessTex = $"";
    public static readonly string _MetallicTex = $"";
    public static readonly string _OcclusionTex = $"";
    public static readonly string DEBUG_MODE = $"Тут немає підсказок, але можете прочитати анекдот: {_newLineTwice} Їдуть три богатиря по полю. Лове їх Орда. Виходе Батий і каже: \"Ну шо богатирі, вот ви і попалісь. Знімайте штани, будем вам хуй мірять. Якщо совокупно метр буде, одпустим, а ні – всій орді сосать будете.\" Ну, перший Ілья Муромець достає, хуй 50 см. Всі такі огооо. Добриня Нікітіч достав – 40 см. Всі такі огоооо. Альоша Поповіч достав, 10 см. Всі поржали, але шо робить, метр наміряли. Їдуть богатирі далі. Ілья каже: \"Якби в мене встав, я б усіх сам відмазав.\" Добриня каже: \"І в мене якби встав теж сам всіх відмазав.\" Альоша каже: \"Я як почув шо сосать будем, в мене аж хуй встав.\"";
    public static readonly string _UseAlpha = $"Для непрозорого: Прозорість: Off, SrcBlend: One, DestBlend: Zero, Render Queue: Geometry {_newLineTwice} Для прозорості: Прозорість: On, SrcBlend: SrcAlpha, DestBlend: OneMinusSrcAlpha, Render Queue: Transparent";
    public static readonly string _SrcBlend = $"";
    public static readonly string _DstBlend = $"";
}
