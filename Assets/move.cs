﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class move : MonoBehaviour
{
    public float min = 2f;
    public float max = 2f;
    // Use this for initialization
    void Start()
    {

        min = transform.position.x;
        max = transform.position.x + 6;

    }

    // Update is called once per frame
    void Update()
    {


        transform.position = new Vector3(Mathf.PingPong(Time.time * 1, max - min) + min, transform.position.y, transform.position.z);

    }
}

