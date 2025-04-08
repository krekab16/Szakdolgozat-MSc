import 'dart:math';

class CosineSimilarity {

  double cosineSimilarity(List<double> vec1, List<double> vec2) {
    double dotProduct = 0.0;
    double magnitude1 = 0.0;
    double magnitude2 = 0.0;
    for (int i = 0; i < vec1.length; i++) {
      dotProduct += vec1[i] * vec2[i];
      magnitude1 += vec1[i] * vec1[i];
      magnitude2 += vec2[i] * vec2[i];
    }
    if (magnitude1 == 0 || magnitude2 == 0) return 0.0;
    return dotProduct / (sqrt(magnitude1) * sqrt(magnitude2));
  }

}