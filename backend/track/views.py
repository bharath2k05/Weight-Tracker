from rest_framework import status
from rest_framework.decorators import api_view
from rest_framework.response import Response
from .models import WeightEntry
from .serializers import WeightEntrySerializer
from django.contrib.auth.models import User
from django.contrib.auth import authenticate, login, logout
from django.db import IntegrityError
from rest_framework_simplejwt.tokens import RefreshToken

@api_view(['POST'])
def user_login(request):
    username = request.data.get('username')
    password = request.data.get('password')
    user = authenticate(request, username=username, password=password)
    
    if user is not None:
        login(request, user)
        
        refresh = RefreshToken.for_user(user)
        access_token = str(refresh.access_token)
        refresh_token = str(refresh)

        return Response({
            'message': 'Login successful',
            'access_token': access_token,
            'refresh_token': refresh_token
        }, status=status.HTTP_200_OK)
    
    else:
        return Response({'error': 'Invalid credentials'}, status=status.HTTP_401_UNAUTHORIZED)

@api_view(['POST'])
def user_logout(request):
    logout(request)
    return Response({'message': 'Logout successful'}, status=status.HTTP_200_OK)

@api_view(['POST'])
def user_register(request):
    username = request.data.get('username')
    password = request.data.get('password')
    
    try:
        user = User.objects.create_user(username=username, password=password)
        return Response({'message': 'Registration successful'}, status=status.HTTP_201_CREATED)
    except IntegrityError:
        return Response({'error': 'Username already exists'}, status=status.HTTP_400_BAD_REQUEST)

@api_view(['POST'])
def add_weight_entry(request):
    
    # print(request.user)
    if request.user.is_authenticated:
        user = request.user
        serializer = WeightEntrySerializer(data=request.data)
        if serializer.is_valid():
            serializer.save(user=user)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    else:
        
        return Response({'error': 'User is not authenticated'}, status=status.HTTP_401_UNAUTHORIZED)

@api_view(['GET'])
def get_weight_entries(request):
    user = request.user
    weight_entries = WeightEntry.objects.filter(user=user).order_by('-timestamp')
    serializer = WeightEntrySerializer(weight_entries, many=True)
    return Response(serializer.data)
