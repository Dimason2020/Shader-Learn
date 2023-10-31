using System;
using UnityEditor;
using UnityEngine;

public class UniversalEditor : ShaderGUI
{
    private MaterialEditor _materialEditor;
    private MaterialProperty[] _properties; // The list of all the properties
    private float _windowWidth;

    PropertyData _mainProperty;
    PropertyData[] _nestedProperties;

    private bool _showBaseGUI;

    // LOGO
    private Texture _logoImage = (Texture)AssetDatabase.LoadAssetAtPath("Assets/Editor/Universal Shader Editor/universal_logo.png", typeof(Texture));
    //private Texture logoImage = (Texture2D) Resources.Load("FlexusLogo");
    private static int _logoPixelsX = 540;
    private static int _logoPixelsY = 100;
    private float _logoSidesRatio = _logoPixelsX / _logoPixelsY;
    private float _basicHeight = 60; // Approximately 2 lines of text? Change this value to increase maximum logo size
    // ----------------



    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties)
    {
        SavePropertiesOfTheCurrentFrame(materialEditor, properties);
        SetUpGlobalStiles();
        DisplayLogo();


        CreatePropertyesBlock(new PropertyData("LIGHT_MODE", TextsLibrary.LIGHT_MODE, false, IconType.InfoSmall));
        DrawHorizontalGUILine();


        CreatePropertyesBlock(new PropertyData("_Color", TextsLibrary._Color, false, IconType.InfoSmall));


        _mainProperty = new PropertyData("USE_GRADIENT", TextsLibrary.USE_GRADIENT, true, IconType.InfoSmall);
        _nestedProperties = new PropertyData[] { new PropertyData("_Color2", TextsLibrary._Color2), new PropertyData("_GradientSettings", TextsLibrary._GradientSettings, false, IconType.InfoSmall) };
        CreatePropertyesBlock(_mainProperty, _nestedProperties);
        DrawHorizontalGUILine();


        _mainProperty = new PropertyData("_UseTexture", TextsLibrary._UseTexture, true);
        _nestedProperties = new PropertyData[] { new PropertyData("UV_MODE", TextsLibrary.UV_MODE, false, IconType.InfoSmall), new PropertyData("_MainTex", TextsLibrary._MainTex, false, IconType.InfoSmall), new PropertyData("_AlbedoAlphaIsOcclusion", TextsLibrary._AlbedoAlphaIsOcclusion, false, IconType.InfoSmall), };
        CreatePropertyesBlock(_mainProperty, _nestedProperties);
        DrawHorizontalGUILine();


        _mainProperty = new PropertyData("_UseNormalMap", TextsLibrary._UseNormalMap, true);
        _nestedProperties = new PropertyData[] { new PropertyData("_NormalMap", TextsLibrary._NormalMap), new PropertyData("_NormalFlipY", TextsLibrary._NormalFlipY, false, IconType.InfoSmall), new PropertyData("_NorBlueIsNonmetallic", TextsLibrary._NorBlueIsNonmetallic, false, IconType.InfoSmall), new PropertyData("_NorAlphaIsRoughness", TextsLibrary._NorAlphaIsRoughness, false, IconType.InfoSmall), };
        CreatePropertyesBlock(_mainProperty, _nestedProperties);
        DrawHorizontalGUILine();


        _mainProperty = new PropertyData("_UseGlow", TextsLibrary._UseGlow, true, IconType.InfoSmall);
        _nestedProperties = new PropertyData[] { new PropertyData("_GlowColor", TextsLibrary._GlowColor), new PropertyData("_GlowPower", TextsLibrary._GlowPower), };
        CreatePropertyesBlock(_mainProperty, _nestedProperties);
        DrawHorizontalGUILine();


        _mainProperty = new PropertyData("_UseSpecular", TextsLibrary._UseSpecular, true, IconType.InfoSmall);
        _nestedProperties = new PropertyData[] { new PropertyData("_SpecularMultiplier", TextsLibrary._SpecularMultiplier) };
        CreatePropertyesBlock(_mainProperty, _nestedProperties);
        DrawHorizontalGUILine();


        _mainProperty = new PropertyData("USE_CUBEMAP", TextsLibrary.USE_CUBEMAP, true, IconType.InfoSmall);
        _nestedProperties = new PropertyData[] { new PropertyData("_Cubemap", TextsLibrary._Cubemap, false, IconType.InfoSmall), new PropertyData("_CubemapColor", TextsLibrary._CubemapColor, false, IconType.InfoSmall), new PropertyData("_CubemapPower", TextsLibrary._CubemapPower, false, IconType.InfoSmall), };
        CreatePropertyesBlock(_mainProperty, _nestedProperties);
        DrawHorizontalGUILine();

        CreatePropertyesBlock(new PropertyData("_Roughness", TextsLibrary._Roughness, false, IconType.InfoSmall));
        CreatePropertyesBlock(new PropertyData("_UniversalHD", TextsLibrary._UniversalHD, false, IconType.InfoSmall));
        DrawHorizontalGUILine();


        _mainProperty = new PropertyData("_UseEmissionTex", TextsLibrary._UseEmissionTex, true);
        _nestedProperties = new PropertyData[] { new PropertyData("_EmissionTex", TextsLibrary._EmissionTex), new PropertyData("_EmissionMultiplier", TextsLibrary._EmissionMultiplier), };
        CreatePropertyesBlock(_mainProperty, _nestedProperties);
        DrawHorizontalGUILine();


        _mainProperty = new PropertyData("_UseCC", TextsLibrary._UseCC, true, IconType.InfoSmall);
        _nestedProperties = new PropertyData[] { new PropertyData("_Saturation", TextsLibrary._Saturation), new PropertyData("_Brightness", TextsLibrary._Brightness), };
        CreatePropertyesBlock(_mainProperty, _nestedProperties);
        DrawHorizontalGUILine();


        _mainProperty = new PropertyData("_TestTextures", TextsLibrary._TestTextures, true);
        _nestedProperties = new PropertyData[] { new PropertyData("_RoughnessTex", TextsLibrary._RoughnessTex), new PropertyData("_MetallicTex", TextsLibrary._MetallicTex), new PropertyData("_OcclusionTex", TextsLibrary._OcclusionTex), };
        CreatePropertyesBlock(_mainProperty, _nestedProperties);
        DrawHorizontalGUILine();


        CreatePropertyesBlock(new PropertyData("DEBUG_MODE", TextsLibrary.DEBUG_MODE, true, IconType.InfoSmall));
        DrawHorizontalGUILine();

        _mainProperty = new PropertyData("_UseAlpha", TextsLibrary._UseAlpha, false, IconType.InfoBig);
        _nestedProperties = new PropertyData[] { new PropertyData("_SrcBlend", TextsLibrary._SrcBlend), new PropertyData("_DstBlend", TextsLibrary._DstBlend), };
        CreatePropertyesBlock(_mainProperty, _nestedProperties);


        _materialEditor.RenderQueueField();
        _materialEditor.DoubleSidedGIField();
        _materialEditor.EnableInstancingField();
        DrawHorizontalGUILine();

        GUIContent outlineHeader = new GUIContent("Обведення", GetIcon(IconType.InfoSmall), "Щоб додати обведення, розкоментуйте пасс і проперті обведення в самому шейдері");
        GUILayout.Label(outlineHeader, EditorStyles.boldLabel);
        IgnoreExceptions(() => CreatePropertyesBlock(new PropertyData("_OutlineScale", TextsLibrary._OutlineScale)));
        IgnoreExceptions(() => CreatePropertyesBlock(new PropertyData("_OutlineColor", TextsLibrary._OutlineColor)));


        // This is to show original GUI
        DrawHorizontalGUILine(30);
        _showBaseGUI = EditorGUILayout.Foldout(_showBaseGUI, "Show Base GUI (Do not touch this)");
        if (_showBaseGUI)
            base.OnGUI(_materialEditor, _properties);
        // ----------------------------
    }


    private void SavePropertiesOfTheCurrentFrame(MaterialEditor materialEditor, MaterialProperty[] properties)
    {
        _materialEditor = materialEditor;
        _properties = properties;
        _windowWidth = EditorGUIUtility.currentViewWidth;
    }


    private void SetUpGlobalStiles()
    {
        if (!EditorGUIUtility.wideMode)
            EditorGUIUtility.wideMode = true;

        EditorGUIUtility.labelWidth = _windowWidth * 0.7f; // This is a minimum size in pixels for the Text part of the Properties.
        EditorGUIUtility.fieldWidth = 65; // This determens the minimum size in pixels for texure dropdown fields (big squares)
    }

    private void DisplayLogo()
    {
        //GUILayout.Label(image, GUILayout.MaxWidth(EditorGUIUtility.standardVerticalSpacing*150f), GUILayout.MaxHeight(EditorGUIUtility.standardVerticalSpacing*40f));
        float logoMaxWidth = Math.Min(_basicHeight * _logoSidesRatio, _windowWidth) - 40;
        float logoMaxHeight = logoMaxWidth / _logoSidesRatio;
        GUILayout.Label(_logoImage, GUILayout.MaxWidth(logoMaxWidth), GUILayout.MaxHeight(logoMaxHeight));
    }

    private void CreatePropertyesBlock(PropertyData mainProperty, PropertyData[] nestedProperties = null) // This fucntion will show a block of properties
    {
        bool shouldWeShowTheRest = ShowProperty(mainProperty); // Display main property of that block

        if (!shouldWeShowTheRest || nestedProperties == null) // Check if we should display anything else
            return;

        //EditorGUI.indentLevel += 2;
        foreach (PropertyData propertyData in nestedProperties) // Display every other property of the block
            ShowProperty(propertyData);
        //EditorGUI.indentLevel -= 2;



        // Local function
        bool ShowProperty(PropertyData propertyData)
        {
            MaterialProperty newProperty = FindProperty(propertyData.name, _properties); // Find property inside the array
            Texture icon = GetIcon(propertyData.iconType); // Find icon

            _materialEditor.ShaderProperty(newProperty, new GUIContent(newProperty.displayName, icon, propertyData.description)); // Display property

            return (!propertyData.isToggle || newProperty.floatValue != 0);  // If property is a Not Toggle for the rest of the properties OR if it is turned On, then return true
        }
    }

    private static void DrawHorizontalGUILine(int height = 5)
    {
        GUILayout.Space(4);

        Rect rect = GUILayoutUtility.GetRect(10, height, GUILayout.ExpandWidth(true));

        rect.height = height;
        rect.xMin = 0;
        rect.xMax = EditorGUIUtility.currentViewWidth;

        Color lineColor = new Color(0.10196f, 0.10196f, 0.10196f, 1);
        EditorGUI.DrawRect(rect, lineColor);
        GUILayout.Space(4);
    }

    private Texture GetIcon(IconType iconType)
    {
        Texture result = null;
        switch(iconType)
        {
            case IconType.QuestionSmall:
                result = EditorGUIUtility.IconContent("_Help").image;
                break;
            case IconType.QuestionBig:
                result = EditorGUIUtility.IconContent("_Help@2x").image;
                break;
            case IconType.Exclamation:
                result = EditorGUIUtility.IconContent("console.warnicon.inactive.sml").image;
                break;
            case IconType.InfoSmall:
                result = EditorGUIUtility.IconContent("console.infoicon.inactive.sml").image;
                break;
            case IconType.InfoBig:
                result = EditorGUIUtility.IconContent("console.infoicon.inactive.sml@2x").image;
                break;
            case IconType.Error:
                result = EditorGUIUtility.IconContent("console.erroricon").image;
                break;
        }

        return result;
    }

    private struct PropertyData
    {
        public PropertyData(string name)
        {
            this.name = name;
            this.description = "";
            this.isToggle = false;
            this.iconType = IconType.Non;
        }
        public PropertyData(string name, string description)
        {
            this.name = name;
            this.description = description;
            this.isToggle = false;
            this.iconType = IconType.Non;
        }
        public PropertyData(string name, string description, bool isToggle)
        {
            this.name = name;
            this.description = description;
            this.isToggle = isToggle;
            this.iconType = IconType.Non;
        }
        public PropertyData(string name, string description, bool isToggle, IconType iconType)
        {
            this.name = name;
            this.description = description;
            this.isToggle = isToggle;
            this.iconType = iconType;
        }

        public string name;
        public string description;
        public bool isToggle;
        public IconType iconType;
    }

    private void IgnoreExceptions(Action action)
    {
        try
        {
            action.Invoke();
        }
        catch { }
    }

    private enum IconType
    {
        QuestionSmall,
        QuestionBig,

        Exclamation,
        InfoSmall,
        InfoBig,
        Error,
        Non
    }
}
