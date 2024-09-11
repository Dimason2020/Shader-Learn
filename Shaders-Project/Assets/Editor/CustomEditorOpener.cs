using UnityEditor;
using System.Diagnostics;
using System.IO;
using UnityEngine;

[InitializeOnLoad]
public class CustomFileOpener
{
    private const string VSPath = "C:\\Program Files\\Microsoft Visual Studio\\2022\\Community\\Common7\\IDE\\devenv.exe";
    private const string VSCodePath = "C:\\Users\\Comfy\\AppData\\Local\\Programs\\Microsoft VS Code\\Code.exe";

    private static string lastClickedAssetPath;
    private static double lastClickTime;

    static CustomFileOpener()
    {
        EditorApplication.projectWindowItemOnGUI += OnProjectWindowItemGUI;
    }

    private static void OnProjectWindowItemGUI(string guid, Rect selectionRect)
    {
        if (Event.current != null && Event.current.type == EventType.MouseDown && Event.current.button == 0 && selectionRect.Contains(Event.current.mousePosition))
        {
            string path = AssetDatabase.GUIDToAssetPath(guid);
            double clickTime = EditorApplication.timeSinceStartup;

            if (path == lastClickedAssetPath && clickTime - lastClickTime < 0.3) // Проверка на двойной клик (менее 0.3 секунд между кликами)
            {
                //if (path.EndsWith(".shader"))
                //{
                //    OpenInVisualStudioCode(path);
                //    Event.current.Use();
                //}
                //else if (path.EndsWith(".cs"))
                //{
                //    OpenInVisualStudio(path);
                //    Event.current.Use();
                //}
            }

            lastClickedAssetPath = path;
            lastClickTime = clickTime;
        }
    }

    private static void OpenInVisualStudio(string path)
    {
        Process.Start(VSPath, Path.GetFullPath(path));
    }

    private static void OpenInVisualStudioCode(string path)
    {
        Process.Start(VSCodePath, Path.GetFullPath(path));
    }
}