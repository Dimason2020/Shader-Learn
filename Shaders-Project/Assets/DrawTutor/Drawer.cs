using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Drawer : MonoBehaviour
{
    [SerializeField] private CustomRenderTexture _texture;
    [SerializeField] private Transform _brush;

    private Material _material;
    private Vector3 _lastBrushPosition;

    private void Awake()
    {
        _material = _texture.material;
        _texture.Initialize();
        _lastBrushPosition = _brush.position;
    }

    private void Update()
    {
        if (_brush.position == _lastBrushPosition) return;

        _lastBrushPosition = _brush.position;
        _material.SetVector("_BrushPosition", new Vector2(_brush.position.x, _brush.position.z));
        _texture.Update();
    }
}
