using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScreenDepthNormal : MonoBehaviour
{
    private Camera mainCamera;

    void Start()
    {
        mainCamera = Camera.main;
        mainCamera.depthTextureMode = DepthTextureMode.Depth;
    }

    // Update is called once per frame
    void Update()
    {

    }
}
