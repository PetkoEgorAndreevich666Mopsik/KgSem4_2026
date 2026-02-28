#pragma once

#include <string>
#include <wrl/client.h>
#include <d3d12.h>

struct Material
{
    std::string Name;

    std::string DiffuseMap1;      // Первая текстура (.tga)
    std::string DiffuseMap2;      // Вторая текстура (.tga)

    UINT SrvHeapIndex1 = 0;        // Индекс SRV для первой текстуры в куче
    UINT SrvHeapIndex2 = 0;        // Индекс SRV для второй текстуры в куче

    Microsoft::WRL::ComPtr<ID3D12Resource> DiffuseTexture1;
    Microsoft::WRL::ComPtr<ID3D12Resource> DiffuseTexture2;
};