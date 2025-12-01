import React, { useState } from 'react';
import {
  StyleSheet,
  Text,
  View,
  TextInput,
  TouchableOpacity,
  ScrollView,
  ActivityIndicator,
  SafeAreaView,
  StatusBar,
  KeyboardAvoidingView,
  Platform,
} from 'react-native';
import axios from 'axios';

// API Configuration
const API_URL = 'http://localhost:8000'; // For iOS simulator
// For physical iPhone, use your Mac's IP: http://192.168.1.XXX:8000

export default function App() {
  const [message, setMessage] = useState('');
  const [chatHistory, setChatHistory] = useState([]);
  const [loading, setLoading] = useState(false);
  const [analysisText, setAnalysisText] = useState('');
  const [analysisResult, setAnalysisResult] = useState(null);
  const [activeTab, setActiveTab] = useState('chat'); // 'chat' or 'analyze'

  // Check API Health
  const checkHealth = async () => {
    try {
      const response = await axios.get(`${API_URL}/health`);
      alert(`✅ API Status: ${response.data.status}\nVersion: ${response.data.version}`);
    } catch (error) {
      alert('❌ Cannot connect to API. Make sure the backend is running!');
      console.error(error);
    }
  };

  // Send Chat Message
  const sendMessage = async () => {
    if (!message.trim()) return;

    const userMessage = message;
    setMessage('');
    setChatHistory(prev => [...prev, { role: 'user', content: userMessage }]);
    setLoading(true);

    try {
      const response = await axios.post(`${API_URL}/api/v1/chat`, {
        message: userMessage,
        temperature: 0.7,
      });

      setChatHistory(prev => [
        ...prev,
        { role: 'assistant', content: response.data.response }
      ]);
    } catch (error) {
      console.error('Chat error:', error);
      setChatHistory(prev => [
        ...prev,
        { role: 'error', content: 'Failed to get response. Check your connection.' }
      ]);
    } finally {
      setLoading(false);
    }
  };

  // Analyze Text
  const analyzeText = async () => {
    if (!analysisText.trim()) return;

    setLoading(true);
    try {
      const response = await axios.post(`${API_URL}/api/v1/analyze`, {
        text: analysisText,
        analysis_type: 'sentiment',
      });

      setAnalysisResult(response.data.result);
    } catch (error) {
      console.error('Analysis error:', error);
      alert('Failed to analyze text. Check your connection.');
    } finally {
      setLoading(false);
    }
  };

  // Clear Chat
  const clearChat = () => {
    setChatHistory([]);
  };

  return (
    <SafeAreaView style={styles.container}>
      <StatusBar barStyle="dark-content" />

      {/* Header */}
      <View style={styles.header}>
        <Text style={styles.headerTitle}>🏔️ Alpine AI</Text>
        <TouchableOpacity onPress={checkHealth} style={styles.healthButton}>
          <Text style={styles.healthButtonText}>Health Check</Text>
        </TouchableOpacity>
      </View>

      {/* Tab Navigation */}
      <View style={styles.tabContainer}>
        <TouchableOpacity
          style={[styles.tab, activeTab === 'chat' && styles.activeTab]}
          onPress={() => setActiveTab('chat')}
        >
          <Text style={[styles.tabText, activeTab === 'chat' && styles.activeTabText]}>
            💬 Chat
          </Text>
        </TouchableOpacity>
        <TouchableOpacity
          style={[styles.tab, activeTab === 'analyze' && styles.activeTab]}
          onPress={() => setActiveTab('analyze')}
        >
          <Text style={[styles.tabText, activeTab === 'analyze' && styles.activeTabText]}>
            🔍 Analyze
          </Text>
        </TouchableOpacity>
      </View>

      {/* Chat Tab */}
      {activeTab === 'chat' && (
        <KeyboardAvoidingView
          behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
          style={styles.content}
        >
          {/* Chat History */}
          <ScrollView style={styles.chatContainer}>
            {chatHistory.length === 0 && (
              <View style={styles.emptyState}>
                <Text style={styles.emptyStateText}>
                  Welcome to Alpine AI! 👋{'\n\n'}
                  Start a conversation below.
                </Text>
              </View>
            )}
            {chatHistory.map((msg, index) => (
              <View
                key={index}
                style={[
                  styles.messageContainer,
                  msg.role === 'user' ? styles.userMessage : styles.assistantMessage,
                ]}
              >
                <Text style={styles.messageRole}>
                  {msg.role === 'user' ? '👤 You' : '🤖 Alpine'}
                </Text>
                <Text style={styles.messageText}>{msg.content}</Text>
              </View>
            ))}
            {loading && (
              <View style={styles.loadingContainer}>
                <ActivityIndicator size="small" color="#007AFF" />
                <Text style={styles.loadingText}>Thinking...</Text>
              </View>
            )}
          </ScrollView>

          {/* Input Area */}
          <View style={styles.inputContainer}>
            {chatHistory.length > 0 && (
              <TouchableOpacity onPress={clearChat} style={styles.clearButton}>
                <Text style={styles.clearButtonText}>Clear</Text>
              </TouchableOpacity>
            )}
            <TextInput
              style={styles.input}
              placeholder="Type your message..."
              value={message}
              onChangeText={setMessage}
              onSubmitEditing={sendMessage}
              returnKeyType="send"
              multiline
            />
            <TouchableOpacity
              onPress={sendMessage}
              style={[styles.sendButton, !message.trim() && styles.sendButtonDisabled]}
              disabled={!message.trim() || loading}
            >
              <Text style={styles.sendButtonText}>Send</Text>
            </TouchableOpacity>
          </View>
        </KeyboardAvoidingView>
      )}

      {/* Analyze Tab */}
      {activeTab === 'analyze' && (
        <View style={styles.content}>
          <ScrollView style={styles.analyzeContainer}>
            <Text style={styles.sectionTitle}>Text Analysis</Text>
            <TextInput
              style={styles.textArea}
              placeholder="Enter text to analyze..."
              value={analysisText}
              onChangeText={setAnalysisText}
              multiline
              numberOfLines={6}
            />

            <TouchableOpacity
              onPress={analyzeText}
              style={[styles.analyzeButton, !analysisText.trim() && styles.analyzeButtonDisabled]}
              disabled={!analysisText.trim() || loading}
            >
              {loading ? (
                <ActivityIndicator size="small" color="#FFF" />
              ) : (
                <Text style={styles.analyzeButtonText}>Analyze Sentiment</Text>
              )}
            </TouchableOpacity>

            {analysisResult && (
              <View style={styles.resultContainer}>
                <Text style={styles.resultTitle}>Analysis Results:</Text>
                <View style={styles.resultCard}>
                  <Text style={styles.resultText}>
                    📊 Word Count: {analysisResult.word_count}
                  </Text>
                  <Text style={styles.resultText}>
                    📝 Character Count: {analysisResult.text_length}
                  </Text>
                  {analysisResult.sentiment && (
                    <>
                      <Text style={styles.resultText}>
                        😊 Sentiment: {analysisResult.sentiment}
                      </Text>
                      <Text style={styles.resultText}>
                        🎯 Confidence: {(analysisResult.confidence * 100).toFixed(0)}%
                      </Text>
                    </>
                  )}
                </View>
              </View>
            )}
          </ScrollView>
        </View>
      )}
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#F5F5F5',
  },
  header: {
    backgroundColor: '#007AFF',
    padding: 16,
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  headerTitle: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#FFF',
  },
  healthButton: {
    backgroundColor: 'rgba(255,255,255,0.2)',
    paddingHorizontal: 12,
    paddingVertical: 6,
    borderRadius: 8,
  },
  healthButtonText: {
    color: '#FFF',
    fontSize: 12,
    fontWeight: '600',
  },
  tabContainer: {
    flexDirection: 'row',
    backgroundColor: '#FFF',
    borderBottomWidth: 1,
    borderBottomColor: '#E0E0E0',
  },
  tab: {
    flex: 1,
    paddingVertical: 16,
    alignItems: 'center',
  },
  activeTab: {
    borderBottomWidth: 3,
    borderBottomColor: '#007AFF',
  },
  tabText: {
    fontSize: 16,
    color: '#666',
  },
  activeTabText: {
    color: '#007AFF',
    fontWeight: '600',
  },
  content: {
    flex: 1,
  },
  chatContainer: {
    flex: 1,
    padding: 16,
  },
  emptyState: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    paddingTop: 100,
  },
  emptyStateText: {
    fontSize: 16,
    color: '#666',
    textAlign: 'center',
  },
  messageContainer: {
    marginBottom: 16,
    padding: 12,
    borderRadius: 12,
  },
  userMessage: {
    backgroundColor: '#007AFF',
    alignSelf: 'flex-end',
    maxWidth: '80%',
  },
  assistantMessage: {
    backgroundColor: '#FFF',
    alignSelf: 'flex-start',
    maxWidth: '80%',
    borderWidth: 1,
    borderColor: '#E0E0E0',
  },
  messageRole: {
    fontSize: 12,
    fontWeight: '600',
    marginBottom: 4,
    color: '#666',
  },
  messageText: {
    fontSize: 16,
    color: '#000',
  },
  loadingContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    paddingVertical: 12,
  },
  loadingText: {
    marginLeft: 8,
    color: '#666',
  },
  inputContainer: {
    flexDirection: 'row',
    padding: 12,
    backgroundColor: '#FFF',
    borderTopWidth: 1,
    borderTopColor: '#E0E0E0',
    alignItems: 'center',
  },
  clearButton: {
    paddingHorizontal: 8,
    paddingVertical: 8,
    marginRight: 8,
  },
  clearButtonText: {
    color: '#FF3B30',
    fontSize: 14,
    fontWeight: '600',
  },
  input: {
    flex: 1,
    backgroundColor: '#F5F5F5',
    borderRadius: 20,
    paddingHorizontal: 16,
    paddingVertical: 10,
    fontSize: 16,
    maxHeight: 100,
  },
  sendButton: {
    backgroundColor: '#007AFF',
    paddingHorizontal: 20,
    paddingVertical: 10,
    borderRadius: 20,
    marginLeft: 8,
  },
  sendButtonDisabled: {
    backgroundColor: '#CCC',
  },
  sendButtonText: {
    color: '#FFF',
    fontWeight: '600',
    fontSize: 16,
  },
  analyzeContainer: {
    flex: 1,
    padding: 16,
  },
  sectionTitle: {
    fontSize: 20,
    fontWeight: 'bold',
    marginBottom: 16,
  },
  textArea: {
    backgroundColor: '#FFF',
    borderRadius: 12,
    padding: 16,
    fontSize: 16,
    borderWidth: 1,
    borderColor: '#E0E0E0',
    marginBottom: 16,
    minHeight: 120,
    textAlignVertical: 'top',
  },
  analyzeButton: {
    backgroundColor: '#007AFF',
    padding: 16,
    borderRadius: 12,
    alignItems: 'center',
    marginBottom: 24,
  },
  analyzeButtonDisabled: {
    backgroundColor: '#CCC',
  },
  analyzeButtonText: {
    color: '#FFF',
    fontSize: 16,
    fontWeight: '600',
  },
  resultContainer: {
    marginTop: 8,
  },
  resultTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    marginBottom: 12,
  },
  resultCard: {
    backgroundColor: '#FFF',
    padding: 16,
    borderRadius: 12,
    borderWidth: 1,
    borderColor: '#E0E0E0',
  },
  resultText: {
    fontSize: 16,
    marginBottom: 8,
    color: '#333',
  },
});
