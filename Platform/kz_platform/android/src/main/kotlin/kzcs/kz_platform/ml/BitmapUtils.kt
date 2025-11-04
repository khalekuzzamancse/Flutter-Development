@file:Suppress("unused")
package kzcs.kz_platform.ml
import android.graphics.Bitmap
import java.nio.ByteBuffer
import java.nio.ByteOrder


object BitmapUtils {
    /**
     * Simply scales a bitmap to the given width and height.
     * ⚠️ If the original bitmap is not square, this may distort the image.
     */
    fun scale(original: Bitmap, width: Int, height: Int): Bitmap {
        return Bitmap.createScaledBitmap(original, width, height, true)
    }
    /**
     * Scales a bitmap to the target width and height **without distortion**.
     *
     * Steps:
     * 1. Crop the bitmap to a square using the smaller side.
     * 2. Center the crop to preserve the main content.
     * 3. Scale the square bitmap to the target width and height.
     *
     * @param original The original bitmap
     * @param width Target width
     * @param height Target height
     * @return A bitmap of size [width] x [height], centered and scaled
     */
    fun scaleAndCenter(original: Bitmap, width: Int, height: Int): Bitmap {
        val minSide = original.width.coerceAtMost(original.height)
        val startX = (original.width - minSide) / 2
        val startY = (original.height - minSide) / 2
        val cropped = Bitmap.createBitmap(original, startX, startY, minSide, minSide)
        return scale(cropped, width, height)
    }

    /**
     * @return a [ByteBuffer] of size = bitmap.width,bitmap.height
     */
    fun convertBitmapToByteBuffer(image: Bitmap): ByteBuffer {
        val bitmap = convertToMutableBitmap(image)
        val width = bitmap.width
        val height = bitmap.height


        // 4 bytes per float, 3 channels (RGB)
        val buffer = ByteBuffer.allocateDirect(4 * width * height * 3)
        buffer.order(ByteOrder.nativeOrder())

        val pixels = IntArray(width * height)
        bitmap.getPixels(pixels, 0, width, 0, 0, width, height)

        for (pixel in pixels) {
            val r = (pixel shr 16) and 0xFF
            val g = (pixel shr 8) and 0xFF
            val b = pixel and 0xFF

            buffer.putFloat(r / 255.0f)
            buffer.putFloat(g / 255.0f)
            buffer.putFloat(b / 255.0f)
        }

        buffer.rewind()
        return buffer
    }
    /**
     * convert the bitmap to a software-configured bitmap
     */
    private fun convertToMutableBitmap(bitmap: Bitmap): Bitmap {
        return bitmap.copy(Bitmap.Config.ARGB_8888, true)
    }


}