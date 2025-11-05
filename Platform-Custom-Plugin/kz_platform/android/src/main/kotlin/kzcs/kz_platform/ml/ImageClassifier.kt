package kzcs.kz_platform.ml

import android.content.Context
import android.graphics.Bitmap
import org.tensorflow.lite.DataType
import org.tensorflow.lite.Interpreter
import org.tensorflow.lite.support.common.FileUtil
import org.tensorflow.lite.support.tensorbuffer.TensorBuffer
import java.nio.MappedByteBuffer

interface ImageClassifier {
    fun classifyOrThrow(image: Bitmap, numClasses: Int): List<Float>
}
/**
 * @param modelPath is the only name of the model+extension, it must belongs the asset directory
 */
class ImageClassifierImpl(context: Context, modelPath: String): ImageClassifier{
    private val modelFile: MappedByteBuffer = FileUtil.loadMappedFile(context, modelPath)
    private val interpreter = Interpreter(modelFile)

    /**
     * @param image must pass the bitmap with the same size that the model except otherwise may throw exception or unexcepted behavior
     * - This assume that the model is classifier and it return a 1D array that represents the confidence of each class.
     * @return An array of floats representing the model's output.
     *         - The size of the array = number of classes the model predicts.
     *         - Each index corresponds to a class in the same order as the labels.
     *         - The value at each index is the model's confidence (probability) for that class.
     *         - To get the predicted class, take the index with the highest value.
     */
    override fun classifyOrThrow(image: Bitmap, numClasses: Int): List<Float> {
        val inputBuffer = BitmapUtils.convertBitmapToByteBuffer(image)
        val outputBuffer = TensorBuffer.createFixedSize(intArrayOf(1, numClasses), DataType.FLOAT32)
        interpreter.run(inputBuffer, outputBuffer.buffer)
        return outputBuffer.floatArray.toList()
    }


}