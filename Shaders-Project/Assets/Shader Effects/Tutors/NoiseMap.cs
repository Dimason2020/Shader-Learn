using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NoiseMap : MonoBehaviour
{
    [SerializeField] private Material material;
    [SerializeField] private Vector3 distance;
    private Vector3 startPosition;
    Vector2 textureOffset = Vector2.zero;
    private enum CalculationMethod { Offset, Scroll}
    [SerializeField] private CalculationMethod calculationMethod;

    private void Start()
    {
        startPosition = transform.position;
    }

    private void Update()
    {
        if(calculationMethod == CalculationMethod.Offset)
            CalculateOffset();
        else 
            CalculateScroll();
    }

    private void CalculateOffset()
    {
        distance = (transform.position - startPosition) / 10;
        textureOffset.x = distance.x;
        textureOffset.y = distance.z;
        material.SetTextureOffset("_HeightMap", -textureOffset);
    }

    private void CalculateScroll()
    {
        distance += new Vector3(Time.deltaTime / 10, 0 , 0);
        textureOffset.x = distance.x;
        textureOffset.y = distance.z;
        material.SetTextureOffset("_HeightMap", -textureOffset);
    }
}
