import cv2
import numpy as np

# Define kernel sizes
kernel_sizes = {
    "Kwadrat 3x3": (3, 3),
    "Kwadrat 33x33": (33, 33),
    "Koło 33x33": (33, 33),
    "Elipsa 33x17": (33, 17)
}

# Generate kernel images
kernel_images = {}
for name, size in kernel_sizes.items():
    if "Kwadrat" in name:
        kernel = np.ones(size, np.uint8)  # Square kernel
    elif "Koło" in name:
        kernel = cv2.getStructuringElement(cv2.MORPH_ELLIPSE, size)  # Circular kernel
    elif "Elipsa" in name:
        kernel = cv2.getStructuringElement(cv2.MORPH_ELLIPSE, size)  # Elliptical kernel
    
    # Save image
    kernel_img_path = f"./{name.replace(' ', '_').lower()}.png"
    cv2.imwrite(kernel_img_path, kernel * 255)  # Save as image (scaled for visibility)
    kernel_images[name] = kernel_img_path
